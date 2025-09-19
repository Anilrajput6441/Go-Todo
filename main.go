package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/thedevsaddam/renderer"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

var rnd *renderer.Render
var db *mongo.Database
var client *mongo.Client
const (
	hostname        string = "localhost:27017"
	dbname          string = "todo"
	collectionName  string = "todo"
	port            string = ":9000"

)

type (
	todoModel struct {
		ID        primitive.ObjectID `bson:"_id,omitempty"`
		Title     string             `bson:"title"`
		Completed bool               `bson:"completed"`
		CreatedAt time.Time          `bson:"created_at"`
	}
	todo struct {
		ID        string    `json:"_id,omitempty"`
		Title     string    `json:"title"`
		Completed bool      `json:"completed"`
		CreatedAt time.Time `json:"created_at"`
	}
)

func init() {
	rnd = renderer.New()
	clientOptions := options.Client().ApplyURI("mongodb://" + hostname)
	client, err := mongo.Connect(context.TODO(), clientOptions)
	checkErr(err)
	db = client.Database(dbname)
}

// func initDB() {
// 	session, err := mgo.Dial(hostname)
// 	if err != nil {
// 		log.Fatal(err)
// 	}
// }

func homeHandler(w http.ResponseWriter, r *http.Request) {
	err := rnd.Template(w, http.StatusOK, []string{"static/home.tpl"}, nil)
	checkErr(err)
}

func fetchTodos(w http.ResponseWriter, r *http.Request) {
	ctx := context.Background()
	cursor, err := db.Collection(collectionName).Find(ctx, bson.M{})
	if err != nil {
		rnd.JSON(w, http.StatusProcessing, renderer.M{
			"message": "Failed to fetch todos",
			"error": err.Error(),
		})
		return
	}
	defer cursor.Close(ctx)

	todoList := []todo{}
	for cursor.Next(ctx) {
		var t todoModel
		if err := cursor.Decode(&t); err != nil {
			continue
		}
		todoList = append(todoList, todo{
			ID: t.ID.Hex(),
			Title: t.Title,
			Completed: t.Completed,
			CreatedAt: t.CreatedAt,
		})
	}

	rnd.JSON(w, http.StatusOK, renderer.M{
		"data": todoList,
	})
}

func createTodo(w http.ResponseWriter, r *http.Request) {

	var t todo

	if err := json.NewDecoder(r.Body).Decode(&t); err != nil {
		rnd.JSON(w, http.StatusProcessing, err)
		return
	}
	if t.Title == "" {
		rnd.JSON(w, http.StatusProcessing, renderer.M{
			"message": "Title is required",
		})
		return
	}

	tm := todoModel{
		ID: primitive.NewObjectID(),
		Title: t.Title,
		Completed: false,
		CreatedAt: time.Now(),
	}
	ctx := context.Background()
	_, err := db.Collection(collectionName).InsertOne(ctx, &tm)
	if err != nil {
		rnd.JSON(w, http.StatusProcessing, renderer.M{
			"message": "Failed to create todo",
			"error": err,
		})
		return
	}
	rnd.JSON(w, http.StatusOK, renderer.M{
		"message": "Todo created successfully",
		"data": tm,
		"todo_id": tm.ID.Hex(),
	})
	
}

func deleteTodo(w http.ResponseWriter, r *http.Request) {
	
	id := strings.TrimSpace(chi.URLParam(r, "id"))
	

	objID, err := primitive.ObjectIDFromHex(id)
	fmt.Println(objID)
	if err != nil {
		rnd.JSON(w, http.StatusProcessing, renderer.M{
			"message": "Invalid todo id",
		})
		return
	}
	ctx := context.Background()
	_, err = db.Collection(collectionName).DeleteOne(ctx, bson.M{"_id": objID})
	if err != nil {
		rnd.JSON(w, http.StatusProcessing, renderer.M{
			"message": "Failed to delete todo",
			"error": err,
		})
		return
	}
	rnd.JSON(w, http.StatusOK, renderer.M{
		"message": "Todo deleted successfully",
		
	})
	
}

func updateTodo(w http.ResponseWriter, r *http.Request) {
	id := strings.TrimSpace(chi.URLParam(r, "id"))
	objID, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		rnd.JSON(w, http.StatusProcessing, renderer.M{
			"message": "Invalid todo id",
		})
		return
	}
	var t todo
	if err := json.NewDecoder(r.Body).Decode(&t); err != nil {
		rnd.JSON(w, http.StatusProcessing, err)
		return
	}
	if t.Title == "" {
		rnd.JSON(w, http.StatusProcessing, renderer.M{
			"message": "Title is required",
		})
		return
	}

	ctx := context.Background()
	_, err = db.Collection(collectionName).UpdateOne(
		ctx,
		bson.M{"_id": objID},
		bson.M{"$set": bson.M{"title": t.Title, "completed": t.Completed}},
	)
	if err != nil {
		rnd.JSON(w, http.StatusProcessing, renderer.M{
			"message": "Failed to update todo",
			"error": err,
		})
		return
	}
	rnd.JSON(w, http.StatusOK, renderer.M{
		"message": "Todo updated successfully",
		"data": t,
		"todo_id": id,
	})
	

}
func main() {
	stopChan := make(chan os.Signal, 1)
	signal.Notify(stopChan, os.Interrupt)
	
	r := chi.NewRouter()
	r.Use(middleware.Logger)
	r.Get("/",homeHandler)
	r.Mount("/todo",todoHandler())

	srv := &http.Server{
		Addr: port,
		Handler: r,
		ReadTimeout: 60 * time.Second,
		WriteTimeout: 60 * time.Second,
		IdleTimeout: 60 * time.Second,
	}

	go func() {
		fmt.Println("Starting the server on port", port)
		if err := srv.ListenAndServe(); err != nil {
			log.Fatal(err)
		}
	}()
	<-stopChan
	fmt.Println("Stopping the server")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	
	// Close MongoDB connection
	if client != nil {
		client.Disconnect(context.Background())
	}
	
	srv.Shutdown(ctx)
	fmt.Println("Server stopped")
	os.Exit(0)
	
}

func todoHandler() http.Handler {
	rg := chi.NewRouter()
	rg.Group(func(r chi.Router) {
		r.Get("/",fetchTodos)
		r.Post("/",createTodo)
		r.Put("/{id}",updateTodo)
		r.Delete("/{id}",deleteTodo)
	})
	return rg
}
func checkErr(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

