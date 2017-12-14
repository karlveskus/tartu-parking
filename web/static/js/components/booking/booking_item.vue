<template>
  <section>
    <h3>{{booking_data.parking.address}}</h3> - <span>Total slots: {{ booking_data.parking.total_slots }}</span>
    <div>
      <p>Selected payment method: {{ parse_payment_method() }}</p>
      <p>From {{parse_date_time(booking_data.start_time)}} to {{get_current_date_time()}}</p>
      <p>Current estimated total: {{calculate_estimated_total()}} EUR</p>
    </div>
    <button v-on:click="finish_parking(booking_data.id)" class="finish-parking">Finish parking</button>
  </section>
</template>

<script>
import axios from "axios";

export default {
  name: "booking_item",
  props: [
    'booking_data',
    'finish_parking'
  ],
  methods: {
    parse_date_time: function(dateTime) {
      const date = dateTime.slice(0, 10).split("-").reverse().join(".");
      const time = (parseInt(dateTime.slice(11, 13)) + 2) + dateTime.slice(13, 19);
      
      return date + " " + time
    },
    get_current_date_time: function() {
      const now = new Date();
      
      return this.parse_date_time(now.toJSON());
    },
    calculate_estimated_total: function() {
      const payment_method = this.booking_data.payment_method;
      const free_time = this.booking_data.parking.zone.free_time;
      const price_per_hour = this.booking_data.parking.zone.price_per_hour;
      const price_per_minute = this.booking_data.parking.zone.price_per_min;
      
      const now = new Date();
      const current_time = now.getTime() + now.getTimezoneOffset()*60*1000;
      const start_time = new Date(this.booking_data.start_time).getTime();
      
      const diff_in_minutes = (current_time - start_time) / 1000 / 60;
      const minutes_to_pay = diff_in_minutes > 15 ? diff_in_minutes - free_time : 0;
      
      let esitmated_total;
        
      if (payment_method === "hourly") {
        esitmated_total = Math.ceil(minutes_to_pay / 60) * price_per_hour;
      } else {
        esitmated_total = minutes_to_pay * price_per_minute;
      }
        
      return esitmated_total;
    },
    parse_payment_method: function() {
      if (this.booking_data.payment_method === 'hourly') return "Hourly"
      else return "Real time"
    }
  },
  
}
</script>

<style scoped lang="scss">
section {
  background: #4285f4;
  box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
  color: white;
  font-size: 16px;
  margin-bottom: 15px;
  position: relative;
  padding: 10px 10px;

  h3 {
    display: inline;
    font-size: 20px;
  }

  button.finish-parking {
    -webkit-tap-highlight-color: #ea4335;
    background: #ea4335;
    border: 0;
    border-radius: 0;
    box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
    color: white;
    font-size: inherit;
    height: 40px;
    margin: 0;
    outline: none;
    position: absolute;
    right: 10px;
    top: 50%;
    transform: translateY(-50%);
    width: 135px;

    &:hover, &:active {
      cursor: pointer;
      background: white;
      color: #ea4335;
    }
  }

}
</style>
