<template>
  <section>
    <div v-if="bookings.length" class="bookings">
      <h2>Currently parking</h2>
      <booking-item v-for="booking in bookings"
        :booking_data="booking" :finish_parking="finish_parking"/>
    </div>
    <div v-if="parking_data_json">
      <h2>Book a new parking</h2>
      <new-booking :parking_data="parking_data_json" :start_parking="start_parking"/>
    </div>
    <button id="back-to-map" v-on:click="navigate_to_map">Back to map</button>
  </section>
  
</template>

<script>
import axios from "axios";
import auth from '../../auth';
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
    'parking_data'
  ],
  methods: {
    finish_parking: function(booking_id) {
      
      axios.defaults.headers.common['Authorization'] = auth.getAuthHeader().Authorization;

      axios.put('api/bookings/' + booking_id)
      .then(() => {
        this.bookings = this.bookings.filter((booking) => {
          return booking.id != booking_id
        })
      })
    },
    start_parking: function() {

      axios.defaults.headers.common['Authorization'] = auth.getAuthHeader().Authorization;

      axios.post('api/bookings/', {parking_id: this.parking_data_json.id})
      .then(() => {
          this.get_started_bookings(this.set_bookings);
          this.parking_data_json = null;
      });
    },
    navigate_to_map: function() {
      window.location.href = '/';
    },
    get_started_bookings: function(cb) {
      axios.defaults.headers.common['Authorization'] = auth.getAuthHeader().Authorization;
    
      const url = "/api/bookings";
    
      axios.get(url)
          .then((res) => {
              cb(res.data.filter((booking) => booking.status == "started"))
          });
    },
    set_bookings: function(bookings) {
      this.bookings = bookings;
    }
  },
  mounted: function() {
    if (this.parking_data) {
      this.parking_data_json = JSON.parse(this.parking_data);
    }
      this.get_started_bookings(this.set_bookings);
  },
}
</script>

<style scoped lang="scss">
section{
  margin: 0 auto;
  position: relative;
  width: 600px;

  @media (max-width: 600px) {
      & {
          width: 100%;
      }
  }

  h2 {
    color: #4285f4;
    font-size: 25px;
    font-weight: 100;
    margin: 20px 10px 10px;
  }

  #back-to-map {
    -webkit-tap-highlight-color: #34a853;
    background: #34a853;
    border: 0;
    border-radius: 0;
    box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
    color: white;
    font-size: inherit;
    height: 40px;
    margin-left: 10px;
    outline: none;
    width: 135px;
    
    &:hover, &:active {
      cursor: pointer;
      background: white;
      color: #34a853;
    }
  }
}
</style>
