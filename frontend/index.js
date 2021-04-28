console.log("test")
fetch('https://api.cloudgate.link/flow1981', {
  method: "GET",
  body: JSON.stringify(),
  headers: {"Content-type": "application/json; charset=UTF-8"}
})
.then(response => response.json()) 
.then(json => console.log(json))
.catch(err => console.log(err));
