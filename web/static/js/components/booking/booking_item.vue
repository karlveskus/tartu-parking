<template>
  <section>
    <h3>{{booking_data.parking.address}}</h3>
    <div>
      Available slots: {{ booking_data.parking.available_slots }} / {{ booking_data.parking.total_slots }}
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
}
</script>

<style scoped lang="scss">
section {
  background: #34a853;
  box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
  color: white;
  font-size: 16px;
  margin-top: 10px;
  position: relative;
  padding: 5px 10px;

  h3 {
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
    height: 70%;
    margin: 0;
    outline: none;
    padding: 0 15px;
    position: absolute;
    right: 0;
    top: 50%;
    transform: translateY(-50%);

    &:hover, &:active {
      cursor: pointer;
      background: white;
      color: #ea4335;
    }
  }

}
</style>
