<template>
  <section>
    <h3>{{ parking_data.address }}</h3>
    <p>Total slots: {{ parking_data.total_slots }}</p>
    <p>Available slots: {{ parking_data.available_slots }}</p>
    <button id="book-parking">Book a spot</button>
  </section>
</template>

<script>
export default {
  props: ['parking_data']
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
