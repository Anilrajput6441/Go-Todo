<!doctype html>
<html lang="en">
  <head>
    <title>Todo</title>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <script type="text/javascript" src="https://unpkg.com/vue@2.3.4"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue-resource@1.3.4"></script>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    <style type="text/css">
      * {
        box-sizing: border-box;
      }
      
      body {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        margin: 0;
        padding: 0;
      }
      
      .container {
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 20px;
      }
      
      .glass-card {
        background: rgba(255, 255, 255, 0.1);
        backdrop-filter: blur(20px);
        border-radius: 15px;
        border: 1px solid rgba(255, 255, 255, 0.2);
        box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        padding: 0;
        width: 100%;
        max-width: 450px;
        overflow: hidden;
      }
      
      .todo-header {
        background: rgba(255, 255, 255, 0.15);
        backdrop-filter: blur(10px);
        color: #fff;
        font-size: 1.8rem;
        font-weight: 700;
        padding: 20px 15px;
        text-align: center;
        margin: 0;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        letter-spacing: 1px;
      }
      
      .todo-content {
        padding: 20px;
        background: rgba(255, 255, 255, 0.05);
      }
      
      .input-container {
        display: flex;
        gap: 8px;
        margin-bottom: 20px;
      }
      
      .glass-input {
        flex: 1;
        background: rgba(255, 255, 255, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 12px;
        padding: 12px 16px;
        color: #fff;
        font-size: 14px;
        backdrop-filter: blur(10px);
        transition: all 0.3s ease;
      }
      
      .glass-input::placeholder {
        color: rgba(255, 255, 255, 0.7);
      }
      
      .glass-input:focus {
        outline: none;
        background: rgba(255, 255, 255, 0.2);
        border-color: rgba(255, 255, 255, 0.4);
        box-shadow: 0 0 20px rgba(255, 255, 255, 0.2);
        transform: translateY(-2px);
      }
      
      .glass-input.error {
        border-color: #ff6b6b;
        box-shadow: 0 0 20px rgba(255, 107, 107, 0.3);
      }
      
      .glass-button {
        background: rgba(255, 255, 255, 0.2);
        border: 1px solid rgba(255, 255, 255, 0.3);
        border-radius: 12px;
        color: #fff;
        padding: 12px 16px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        backdrop-filter: blur(10px);
        min-width: 50px;
      }
      
      .glass-button:hover {
        background: rgba(255, 255, 255, 0.3);
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
      }
      
      .glass-button.btn-success {
        background: rgba(46, 204, 113, 0.3);
        border-color: rgba(46, 204, 113, 0.5);
      }
      
      .glass-button.btn-success:hover {
        background: rgba(46, 204, 113, 0.5);
      }
      
      .glass-button.btn-warning {
        background: rgba(241, 196, 15, 0.3);
        border-color: rgba(241, 196, 15, 0.5);
      }
      
      .glass-button.btn-warning:hover {
        background: rgba(241, 196, 15, 0.5);
      }
      
      .todo-list {
        list-style: none;
        padding: 0;
        margin: 0;
      }
      
      .todo-item {
        background: rgba(255, 255, 255, 0.1);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 12px;
        margin-bottom: 10px;
        padding: 15px;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 12px;
      }
      
      .todo-item:hover {
        background: rgba(255, 255, 255, 0.15);
        transform: translateY(-2px);
        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
      }
      
      .todo-item.completed {
        background: rgba(46, 204, 113, 0.2);
        border-color: rgba(46, 204, 113, 0.3);
      }
      
      .todo-item.completed .todo-text {
        text-decoration: line-through;
        opacity: 0.7;
      }
      
      .todo-icon {
        font-size: 20px;
        width: 24px;
        text-align: center;
      }
      
      .todo-icon.fa-circle {
        color: rgba(255, 255, 255, 0.6);
      }
      
      .todo-icon.fa-check-circle {
        color: #2ecc71;
      }
      
      .todo-text {
        flex: 1;
        color: #fff;
        font-size: 14px;
        font-weight: 500;
        margin: 0;
      }
      
      .todo-actions {
        display: flex;
        gap: 8px;
      }
      
      .action-button {
        background: rgba(255, 255, 255, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 6px;
        color: #fff;
        padding: 6px 10px;
        font-size: 12px;
        cursor: pointer;
        transition: all 0.3s ease;
        backdrop-filter: blur(5px);
      }
      
      .action-button:hover {
        background: rgba(255, 255, 255, 0.2);
        transform: scale(1.05);
      }
      
      .action-button.btn-danger:hover {
        background: rgba(231, 76, 60, 0.3);
        border-color: rgba(231, 76, 60, 0.5);
      }
      
      .action-button.btn-success:hover {
        background: rgba(46, 204, 113, 0.3);
        border-color: rgba(46, 204, 113, 0.5);
      }
      
      .del {
        text-decoration: line-through;
      }
      
      @media (max-width: 768px) {
        .container {
          padding: 10px;
        }
        
        .todo-header {
          font-size: 2rem;
          padding: 20px 15px;
        }
        
        .todo-content {
          padding: 20px;
        }
        
        .input-container {
          flex-direction: column;
        }
        
        .glass-button {
          width: 100%;
        }
      }
      
      /* Animation for new todos */
      .todo-item {
        animation: slideIn 0.3s ease-out;
      }
      
      @keyframes slideIn {
        from {
          opacity: 0;
          transform: translateY(20px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }
    </style>
  </head>
  <body>
    <div class="container" id="root">
        <div class="glass-card">
          <h1 class="todo-header">
            ✨ Daily Todo Lists ✨
          </h1>
          <div class="todo-content">
              <form v-on:submit.prevent>
                <div class="input-container">
                  <input type="text" v-model="todo.title" v-on:keyup="checkForEnter($event)" class="glass-input" :class="{ 'error': showError }" placeholder="Add your new todo...">
                  <button class="glass-button" :class="{'btn-success' : !enableEdit, 'btn-warning' : enableEdit}" type="button" v-on:click="addTodo">
                    <span :class="{'fa fa-plus' : !enableEdit, 'fa fa-edit' : enableEdit}"></span>
                  </button>
                </div>
              </form>
              <ul class="todo-list">
                <li class="todo-item" :class="{ 'completed': todo.completed }" v-for="(todo, todoIndex) in todos" v-on:click="toggleTodo(todo, todoIndex)">
                    <i class="todo-icon" :class="{'fa fa-circle': !todo.completed, 'fa fa-check-circle': todo.completed }"></i>
                    <span class="todo-text" :class="{ 'del': todo.completed }">@{ todo.title }</span>
                    <div class="todo-actions">
                      <button type="button" class="action-button btn-success" v-on:click.prevent.stop v-on:click="editTodo(todo, todoIndex)">
                        <span class="fa fa-edit"></span>
                      </button>
                      <button type="button" class="action-button btn-danger" v-on:click.prevent.stop v-on:click="deleteTodo(todo, todoIndex)">
                        <span class="fa fa-trash"></span>
                      </button>
                    </div>
                </li>
              </ul>
          </div>
        </div>
    </div>
    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>
    <script type="text/javascript">
      var Vue = new Vue({
        el: '#root',
        delimiters: ['@{', '}'],
        data: {
          showError: false,
          enableEdit: false,
          todo: {_id: '', title: '', completed: false},
          todos: []
        },
        mounted () {
          this.$http.get('todo').then(response => {
            this.todos = response.body.data;
          });
        },
        methods: {
          addTodo(){
            if (this.todo.title == ''){
              this.showError = true;
            }else{
              this.showError = false;
              if(this.enableEdit){
                this.$http.put('todo/'+this.todo._id, this.todo).then(response => {
                  if(response.status == 200){
                    this.todos[this.todo.todoIndex] = this.todo;
                  }
                });
                this.todo = {_id: '', title: '', completed: false};
                this.enableEdit = false;
              }else{
                this.$http.post('todo', {title: this.todo.title}).then(response => {
                  if(response.status == 201){
                    this.todos.push({_id: response.body.todo_id, title: this.todo.title, completed: false});
                    this.todo = {_id: '', title: '', completed: false};
                  }
                });
              }
            }
          },
          checkForEnter(event){
            if (event.key == "Enter") {
              this.addTodo();
            }
          },
          toggleTodo(todo, todoIndex){
            var completedToggle;
            if (todo.completed == true) {
              completedToggle = false;
            }else{
              completedToggle = true;
            }
            this.$http.put('todo/'+todo._id, {_id: todo._id, title: todo.title, completed: completedToggle}).then(response => {
              if(response.status == 200){
                this.todos[todoIndex].completed = completedToggle;
              }
            });
          },
          editTodo(todo, todoIndex){
            this.enableEdit = true;
            this.todo = todo;
            this.todo.todoIndex = todoIndex;
          },
          deleteTodo(todo, todoIndex){
            if(confirm("Are you sure ?")){
              this.$http.delete('todo/'+todo._id).then(response => {
                
                if(response.status == 200){
                  this.todos.splice(todoIndex, 1);
                  this.todo = {_id: '', title: '', completed: false};
                }
              });
            }
          }
        }
      });
    </script>
  </body>
</html>