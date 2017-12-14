import axios from "axios";

export default {
  user: { username: "" },
  login: function (context, creds, redirect) {
    axios.post("/api/sessions", creds)
      .then(response => {
        this.username = creds.username;
        window.localStorage.setItem('username', this.username)
        window.localStorage.setItem('token', response.data.token);
        if (redirect)
          window.location.replace("/");
      })
      .catch(error => {
        console.log(error);
      });
    },
    logout: function(context, options) {
      axios.delete("/api/sessions/1", options)
        .then(response => {
          window.localStorage.removeItem('token');
          window.localStorage.removeItem('username');
          this.user.authenticated = false;
          this.user.username = "";
          
          window.location.replace("/");
        }).catch(error => {
          console.log(error)
        });
    },
    authenticated: function() {
      const jwt = window.localStorage.getItem('token');
      return !!jwt;
    },
    getAuthHeader: function() {
      return {
        'Authorization': window.localStorage.getItem('token') // TODO: hard-coded to user
      }
    }
}