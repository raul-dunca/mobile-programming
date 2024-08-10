var koa = require('koa');
var app = module.exports = new koa();
const server = require('http').createServer(app.callback());
const WebSocket = require('ws');
const wss = new WebSocket.Server({ server });
const Router = require('koa-router');
const cors = require('@koa/cors');
const bodyParser = require('koa-bodyparser');

app.use(bodyParser());

app.use(cors());

app.use(middleware);

function middleware(ctx, next) {
  const start = new Date();
  return next().then(() => {
    const ms = new Date() - start;
    console.log(`${start.toLocaleTimeString()} ${ctx.response.status} ${ctx.request.method} ${ctx.request.url} - ${ms}ms`);
  });
}


const pets = [
 
];

const router = new Router();
router.get('/all', ctx => {
  ctx.response.body = pets;
  ctx.response.status = 200;
});



const broadcast = (action,data) =>
  wss.clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(JSON.stringify({
        'action':action,
        'data':data}));
    }
  });

router.post('/pet', ctx => {

  const headers = ctx.request.body;
  console.log("POST body: " + JSON.stringify(headers));
  const name = headers.name;
  const type = headers.type;
  const location = headers.location;
  const gender = headers.gender;
  const breed = headers.breed;
  const age = headers.age;
  const contact = headers.contact;
  if (typeof name !== 'undefined'
    && typeof type !== 'undefined'
    && typeof location !== 'undefined'
    && typeof gender !== 'undefined'
    && typeof breed !== 'undefined'
    && typeof age !== 'undefined'
    && typeof contact !== 'undefined') {
      let maxId;
      if (pets.length===0)
      {
        maxId=1;
      }
      else
      {
      maxId=Math.max.apply(Math, pets.map(obj => obj._id)) + 1;
      }
      
      let obj = {
        _id: maxId,
        name,
        type,
        location,
        gender,
        breed,
        age,
        contact
      };
      pets.push(obj);
      broadcast('add',obj);
      ctx.response.body = { _id: obj._id };
      ctx.response.status = 200;
  } else {
    const msg = `Missing or invalid data for pet creation with name: ${name}, type: ${type}, breed: ${breed}, location: ${location}, gender: ${gender}, age: ${age}, contact: ${contact}`;
    console.log(msg);
    ctx.response.body = { text: msg };
    ctx.response.status = 404;
  }
});


router.put('/pet/:id', ctx => {
  const { id } = ctx.request.params;
  const {name, type, location, gender, breed, age, contact } = ctx.request.body;

  console.log("PUT params: " + JSON.stringify(ctx.params));
  console.log("PUT body: " + JSON.stringify(ctx.request.body));

  const index = pets.findIndex(pet => pet._id == id);

  if (index === -1) {
    ctx.response.body = { text: `No pet found with ID: ${id}` };
    ctx.response.status = 404;
  } else {
    const updatedPet = {
      _id: Number(id),
      name,
      type,
      location,
      gender,
      breed,
      age: Number(age),
      contact
    };

    pets[index] = updatedPet;
    broadcast('update',updatedPet);

    ctx.response.body = updatedPet;
    ctx.response.status = 200;
  }
});

router.del('/pet/:id', ctx => {

   console.log("DELETE params: " + JSON.stringify(ctx.params));
  const headers = ctx.params;

  const _id = headers.id;
  if (typeof _id !== 'undefined') {
    const index = pets.findIndex(obj => obj._id == _id);
    if (index === -1) {
      const msg = "No pet with id: " + id;
      console.log(msg);
      ctx.response.body = { text: msg };
      ctx.response.status = 404;
    } else {
      let obj = pets[index];
      pets.splice(index, 1);
      broadcast('delete',obj._id);
      ctx.response.body = { _id: obj._id };
      ctx.response.status = 200;
    }
  } else {
    ctx.response.body = { text: 'Id missing or invalid' };
    ctx.response.status = 404;
  }
});

app.use(router.routes());
app.use(router.allowedMethods());

const port = 2320;

server.listen(port, () => {
  console.log(`🚀 Server listening on ${port} ... 🚀`);
});