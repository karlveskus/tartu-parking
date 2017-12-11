import axios from "axios";

export default {
  user: { username: "" }, 
  login: function (context, creds, redirect) {
    axios.post("/api/sessions", creds)
      .then(response => {
        this.username = creds.username;
        window.localStorage.setItem('token-'+this.username, response.data.token);
console.log("I am here");
console.log(context.$router);
        if (redirect)
          //context.$router.push({path: redirect});
          window.location.replace("/");
      })
      .catch(error => {
        console.log(error);
      });
    },
    logout: function(context, options) {
      axios.delete("/api/sessions/1", options)
        .then(response => {
          window.localStorage.removeItem('token-'+this.username);
          this.user.authenticated = false;
          this.user.username = "";
          context.$router.push({path: '/login'});
        }).catch(error => {
          console.log(error)
        });
    },
    authenticated: function() {
      const jwt = window.localStorage.getItem('token-'+this.username);
      return !!jwt;
    },
    getAuthHeader: function() {
      return {
        'Authorization': window.localStorage.getItem('token-'+this.username)
      }
    }
}