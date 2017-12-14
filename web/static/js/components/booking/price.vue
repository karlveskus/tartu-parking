<template>
    <section>
        <h2>{{ booking_data.message }}</h2>
        <div>
            <p>{{ booking_data.address }}</p>
            <p>Start time {{ parse_date_time(booking_data.start_time) }}</p>
            <p>End time {{ parse_date_time(booking_data.end_time) }}</p>
            <p>Price: {{ booking_data.price }} EUR</p>
        </div>
    </section>
</template>

<script>
  import parser from '../../parser';

  export default {
    props: [
      'booking_data'
    ],
    methods: {
      parse_date_time: function (data_time) {
        return parser.parse_date_time(data_time)
      },
    }
  }
</script>

<style scoped lang="scss">
    section {
        padding: 0;
        margin: 0;
        
        h2 {
            color: #4285F4;
            font-size: 25px;
            font-weight: 100;
            margin: 20px 10px 10px;
        }
        
        div {
            background: #4285F4;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
            color: white;
            font-size: 16px;
            position: relative;
            padding: 10px 10px;
            
            p:first-child {
                font-size: 16px;
                margin-bottom: 5px;
            }
            
            p:last-child {
                margin-top: 5px;
            }
        }
    }
</style>
