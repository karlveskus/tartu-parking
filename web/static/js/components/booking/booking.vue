<template>
  <div>
    <!-- {{ parking_id }}<br> -->
    <h2>Currently parking</h2>
    <booking-item v-for="booking in bookings" 
      :booking_data="booking" :finish_parking="finish_parking"/>
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
  methods: {
    finish_parking: function(booking_id) {

      axios.defaults.headers.common['user_id'] = this.user_id;

      axios.delete('api/bookings/' + booking_id)
      .then(() => {
        this.bookings = this.bookings.filter((booking) => {
          return booking.id != booking_id
        })
      })
    }
  },
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

<style scoped lang="scss">
div{
  margin: 0 auto;
  width: 600px;

  @media (max-width: 600px) {
      & {
          width: 100%;
      }
  }

  h2 {
    color: #4285f4;
    font-size: 25px;
    margin: 15px 15px 10px;
  }


}
</style>
