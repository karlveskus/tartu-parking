export default {
  parse_date_time: function (dateTime) {
    const date = dateTime.slice(5, 10).split("-").reverse().join(".");
    let hours = parseInt(dateTime.slice(11, 13)) + 2;

    hours = hours < 10 ? "0" + hours : hours;

    let time = hours + dateTime.slice(13, 16);

    return date + " " + time;
  }
}