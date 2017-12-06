<template>
  <section>
    <h2>Currently parking</h2>
    <booking-item v-for="booking in bookings" 
      :booking_data="booking" :finish_parking="finish_parking"/>
    <div v-if="parking_data_json" >
      <h2>Book a new parking</h2>
      <new-booking :parking_data="parking_data_json" />
    </div>
  </section>
  
</template>

<script>
import axios from "axios";
import booking_item from './booking_item.vue';
import new_booking from './new_booking.vue';

export default {
  data: function() {
    return {
      bookings: [],
      parking_data_json: null
    }
  },
  components: {
    'booking-item': booking_item,
    'new-booking': new_booking
  },
  props: [
    'parking_data',
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
    },
  },
  mounted: function() {
    const url = "/api/bookings";
      this.parking_data_json = JSON.parse(this.parking_data);
      
      axios.defaults.headers.common['user_id'] = this.user_id;

      axios.get(url)
      .then((res) => {
        this.bookings = res.data
      });
  }
}
</script>

<style scoped lang="scss">
section{
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
    margin: 20px 10px 10px;
  }


}
</style>
