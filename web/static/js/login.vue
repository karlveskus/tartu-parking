<template>
    <div>
        <br>
        <br>
        <div style="margin-left: 400px; margin-right: 400px;">
            <h2>Login</h2>
        <hr>
        <br>
            <div>
                <div class="form-group">
                    <label for="username">Username:</label>
                    <input type="text" id="username" v-model="username">
                </div>
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" id="password" v-model="password">
                </div>
                <br>
                <div align="center" style="font-size: 18px;">Not registred yet? <a href="/users/new" style="align:center;">Click here</a></div>
                 <br>
                <input type="submit" v-on:click="login" value="Submit" />
            </div>
        </div>
    </div>
</template>

<script>
import axios from "axios";
import auth from "./auth";

export default {
    data: function () {
        return {
            username: "",
            password: ""
        }
    },
    methods: {
        login: function() {
            console.log(`Username ${this.username}, password ${this.password}`);
            auth.login(this, {username: this.username, password: this.password}, "/");
        }
    }
}
</script>

<style>
    input[type=text], select {
    width: 100%;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
  }

   input[type=password], select {
    width: 100%;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
}

input[type=submit] {
    width: 100%;
    background-color: #4CAF50;
    color: white;
    padding: 14px 20px;
    margin: 8px 0;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

input[type=submit]:hover {
    background-color: #45a049;
}

h2 {
    display: block;
    font-size: 1.5em;
    margin-top: 0.83em;
    margin-bottom: 0.83em;
    margin-left: 0;
    margin-right: 0;
    font-weight: bold;
}

</style>
