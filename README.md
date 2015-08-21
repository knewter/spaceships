## Spaceships

**Spaceships** is an elixir application that simulates a number of spaceships
moving around.  There's a 'board' that a bunch of ships can live on (currently
poorly named `Spaceships.State`, which is a GenServer.  Each ship is responsible
for updating itself, and is implemented as its own GenServer.  There's also a
window that is not yet functional that will render the spaceships as dots on a
black background eventually.
