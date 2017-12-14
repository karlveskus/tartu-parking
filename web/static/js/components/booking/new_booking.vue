<template>
  <section>
    <h3>{{ parking_data.address }}</h3>
    <p>Total slots: {{ parking_data.slots.total }}</p>
    <br />
    <h4>{{ parking_data.zone.name }}</h4>
    <p> Free time {{ parking_data.zone.free_time }} minutes</p>
    <p> Price per hour {{ parking_data.zone.price_per_hour }} EUR</p>
    <p> Price per minute {{ parking_data.zone.price_per_min }} EUR</p>
    <select v-model="payment_method">
      <option value="hourly">Hourly payment</option>
      <option value="real-time">Real-time payment</option>
    </select>
    <button id="book-parking" v-on:click="start_parking(payment_method)">Book a spot</button>
  </section>
</template>

<script>
export default {
  data: function () {
    return {
      payment_method: 'hourly'
    }
  },
  props: [
    'parking_data',
    'start_parking'
  ]
}
</script>

<style scoped lang="scss">
section {
  background: #4285f4;
  box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
  color: white;
  margin-bottom: 15px;
  padding: 10px;
  position: relative;

  h3 {
    font-size: 20px;
  }
  
  h4 {
    font-size: 17px;
  }

  #book-parking {
    -webkit-tap-highlight-color: #34a853;
    background: #34a853;
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
      color: #34a853;
    }
  }
}
</style>
