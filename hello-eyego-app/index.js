const express = require('express');
const app = express();

// API Route
app.get('/api/hello', (req, res) => {
  res.json({ message: 'Hello Eyego' });
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
