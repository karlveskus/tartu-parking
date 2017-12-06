<template>
  <div>{{ parking_id }} - {{ bookings }}</div>
</template>

<script>
import axios from "axios";

export default {
  data: function() {
    return {
      bookings: []
    }
  },
  props: ['parking_id', 'user_id'],
  mounted: function() {
    const url = "/api/bookings";
      axios.defaults.headers.common['user_id'] = this.user_id;

      axios.get(url)
      .then((res) => {
        this.bookings = res.data
      });
  }
}
</script>

<style>

</style>
