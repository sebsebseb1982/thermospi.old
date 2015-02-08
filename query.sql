select sensorId, date, AVG(value) from records group by sensorId, MONTH(date) order by sensorId, date;
