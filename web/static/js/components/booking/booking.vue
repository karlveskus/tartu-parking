<template>
  <div>
    {{ parking_id }}<br>
    <ul>
      <li v-for="booking in bookings">
        <booking-item data="booking"/>
      </li>
    </ul>
  </div>
</template>

<script>
import axios from "axios";
import booking_item from './booking_item.vue';

export default {
  data: function() {
    return {
      bookings: []
    }
  },
  components: {
    'booking-item': booking_item
  },
  props: [
    'parking_id',
    'user_id'
  ],
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
