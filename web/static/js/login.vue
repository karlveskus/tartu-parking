<template>
    <section>
        <h2>Login</h2>
        <div>
            <div class="error">{{ errorMsg }}</div>
            <input type="text" id="username" v-model="username">
            <input type="password" id="password" v-model="password">
            <div align="center" style="font-size: 18px;">Not registred yet? <a href="/users/new" style="align:center;">Click here</a>
                <input id="log-in-button" type="submit" v-on:click="login" value="Submit" />
            </div>
        </div>
    </section>
</template>

<script>
  import axios from "axios";
  import auth from "./auth";

  export default {
    data: function () {
      return {
        username: "",
        password: "",
        errorMsg: ""
      }
    },
    methods: {
      login: function () {
        console.log(`Username ${this.username}, password ${this.password}`);
        auth.login(this, {username: this.username, password: this.password}, "/");
        this.errorMsg = auth.error;
      }
    }
  }
</script>

<style scoped lang="scss">
    section {
        margin: 0 auto;
        width: 600px;
        
        @media (max-width: 600px) {
            & {
                width: 100%;
            }
        }
        
        h2 {
            font-size: 1.5em;
            margin: 20px 10px;
            font-weight: bold;
        }
        
        .error {
            color: red;
            text-align: center;
        }
        
        div {
            padding: 0 10px;
            
            input {
                width: 100%;
                padding: 12px 15px;
                margin: 8px 0;
                display: block;
                border: 1px solid #CCC;
                border-radius: 4px;
                box-sizing: border-box;
            }
            
            input[type=submit] {
                width: 100%;
                background-color: #4CAF50;
                color: white;
                padding: 14px 20px;
                margin: 0;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
            
            input[type=submit]:hover {
                background-color: #45A049;
            }
        }
    }

</style>
