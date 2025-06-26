const express = require("express");
const bodyParser = require("body-parser");
const sql = require("mssql/msnodesqlv8");
const cors = require("cors");

const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// SQL Server Configuration using Windows Authentication
const config = {
  connectionString:
    "Driver={ODBC Driver 17 for SQL Server};Server=localhost\\SQLEXPRESS;Database=db_billingsystem;Trusted_Connection=Yes;",
};

// --- User Signup ---
app.post("/signup", async (req, res) => {
  const { name, email, phone_number, password, role } = req.body;
  try {
    await sql.connect(config);
    await sql.query(`
      INSERT INTO users (name, email, phone_number, password_hash, role)
      VALUES ('${name}', '${email}', '${phone_number}', '${password}', '${role}')
    `);
    res.status(200).send("✅ User registered successfully!");
  } catch (err) {
    console.error("❌ DB Insertion Error:", err);
    res.status(500).send("❌ Error inserting user data.");
  }
});

// --- User Login ---
app.post("/login", async (req, res) => {
  const { email, password } = req.body;

  try {
    const pool = await sql.connect(config);
    const result = await pool
      .request()
      .input("email", sql.NVarChar, email)
      .query("SELECT * FROM users WHERE email = @email");

    if (result.recordset.length === 0) {
      return res.status(401).send("Invalid email or password");
    }

    const user = result.recordset[0];

    // Directly compare plain-text passwords (Not secure, just for testing!)
    if (user.password_hash !== password) {
      return res.status(401).send("Invalid email or password");
    }

    res.status(200).json({
      message: "Login successful",
      role: user.role,
      name: user.name,
      email: user.email
    });
  } catch (err) {
    console.error("Login error:", err);
    res.status(500).send("Server error");
  }
});


// --- Add Product ---
app.post("/products/add", async (req, res) => {
  const { name, price, stock } = req.body;
  try {
    const pool = await sql.connect(config);
    await pool.request()
      .input("name", sql.NVarChar, name)
      .input("price", sql.Float, price)
      .input("stock", sql.Int, stock)
      .query("INSERT INTO Products (Name, Price, Stock) VALUES (@name, @price, @stock)");
    res.send("Product added");
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// --- Update Product ---
app.post("/products/update", async (req, res) => {
  const { name, price, stock } = req.body;
  try {
    const pool = await sql.connect(config);
    await pool.request()
      .input("name", sql.NVarChar, name)
      .input("price", sql.Float, price)
      .input("stock", sql.Int, stock)
      .query("UPDATE Products SET Price = @price, Stock = @stock WHERE Name = @name");
    res.send("Product updated");
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// --- Delete Product ---
app.post("/products/delete", async (req, res) => {
  const { name, quantity } = req.body;

  try {
    const result = await sql.query`SELECT * FROM Products WHERE name = ${name}`;

    if (result.recordset.length === 0) {
      return res.status(404).send("Product not found.");
    }

    const product = result.recordset[0];
    const currentStock = parseInt(product.stock);

    if (!quantity || quantity.toLowerCase() === "all") {
      await sql.query`DELETE FROM Products WHERE name = ${name}`;
      return res.send("Product deleted entirely.");
    }

    const qtyToDelete = parseInt(quantity);

    if (isNaN(qtyToDelete) || qtyToDelete <= 0) {
      return res.status(400).send("Invalid quantity.");
    }

    if (qtyToDelete >= currentStock) {
      await sql.query`DELETE FROM Products WHERE name = ${name}`;
      return res.send("Quantity >= stock. Product deleted.");
    } else {
      const newStock = currentStock - qtyToDelete;
      await sql.query`UPDATE Products SET stock = ${newStock} WHERE name = ${name}`;
      return res.send(`Deleted ${qtyToDelete}. Remaining stock: ${newStock}`);
    }
  } catch (err) {
    console.error("Error deleting product:", err);
    res.status(500).send("Server error.");
  }
});

// Get all products
app.get("/products", async (req, res) => {
  try {
    await sql.connect(config);
    const result = await sql.query("SELECT id, name, price, stock FROM Products");
    res.json(result.recordset);
  } catch (err) {
    console.error(err);
    res.status(500).send("Error retrieving products");
  }
});

// Get out of stock products
app.get("/products/outofstock", async (req, res) => {
  try {
    await sql.connect(config);
    const result = await sql.query("SELECT id, name, price, stock FROM Products WHERE stock = 0");
    res.json(result.recordset);
  } catch (err) {
    console.error(err);
    res.status(500).send("Error retrieving out-of-stock products");
  }
});

// Get total products count
app.get("/products/count", async (req, res) => {
  try {
    await sql.connect(config);
    const result = await sql.query("SELECT COUNT(*) AS total FROM Products");
    res.json(result.recordset[0]);
  } catch (err) {
    console.error(err);
    res.status(500).send("Error retrieving product count");
  }
});

// --- SHOP PAGE ---
app.get("/products", async (req, res) => {
  try {
    const result = await sql.query`SELECT * FROM Products`;
    res.json(result.recordset);
  } catch (error) {
    console.error("Error fetchin products:", error);
    req.status(500).send("Server error");
  }
});

// CART
app.post("/cart", async (req, res) => {
  const { userId, productId, quantity } = req.body;

  try {
    // Check if the product is already in the cart
    const check = await sql.query`SELECT * FROM Cart WHERE userId = ${userId} AND productId = ${productId}`;

    if (check.recordset.length > 0) {
      // Update quantity if product already exists in cart
      await sql.query`
        UPDATE Cart 
        SET quantity = quantity + ${quantity}
        WHERE userId = ${userId} AND productId = ${productId}`;
    } else {
      // Otherwise, insert new row
      await sql.query`
        INSERT INTO Cart (userId, productId, quantity)
        VALUES (${userId}, ${productId}, ${quantity})`;
    }

    res.status(200).json({ message: "Added to cart successfully!" });
  } catch (err) {
    console.error("Error adding to cart:", err);
    res.status(500).send("Server error");
  }
});

// --- CART PAGE ---
app.get("/cart/:userId", async (req, res) => {
  const { userId } = req.params;
  try {
    const result = await sql.query`
      SELECT Cart.productId, Products.name, Products.price, Cart.quantity 
      FROM Cart 
      JOIN Products ON Cart.productId = Products.id
      WHERE Cart.userId = ${userId}
    `;
    res.json(result.recordset);
  } catch (err) {
    res.status(500).send("Error retrieving cart");
  }
});

// UPDATE QUANTITY
app.put("/cart/update", async (req, res) => {
  const { userId, productId, quantity } = req.body;
  try {
    await sql.query`
      UPDATE Cart 
      SET quantity = ${quantity}
      WHERE userId = ${userId} AND productId = ${productId}`;
    res.send("Quantity updated");
  } catch (err) {
    res.status(500).send("Error updating quantity");
  }
});

//DELETE ITEM
app.delete("/cart", async (req, res) => {
  const { userId, productId } = req.body;
  try {
    await sql.query`
      DELETE FROM Cart 
      WHERE userId = ${userId} AND productId = ${productId}`;
    res.send("Item deleted");
  } catch (err) {
    res.status(500).send("Error deleting item");
  }
});

// --- USER PROFILE PAGE ---

// Get user profile by ID
app.get('/user/:id', async (req, res) => {
  const userId = req.params.id;

  try {
    const pool = await sql.connect(config);  // ensure config is your SQL connection config
    const result = await pool
      .request()
      .input("userId", sql.Int, userId)
      .query("SELECT id, name, email, phone_number, role, created_at FROM users WHERE id = @userId");

    if (result.recordset.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json(result.recordset[0]);
  } catch (err) {
    console.error("Error fetching user:", err);
    res.status(500).json({ error: "Server error" });
  }
});


// Update user info
// Assuming Express + mssql + bcrypt setup
app.put("/user/:id", async (req, res) => {
  const userId = req.params.id;
  const { name, phone_number, email, password } = req.body;

  try {
    let query = "UPDATE Users SET name = @name, phone_number = @phone_number, email = @email";
    if (password) {
      const hashedPassword = await bcrypt.hash(password, 10);
      query += ", password = @password";
    }
    query += " WHERE id = @id";

    const request = new sql.Request();
    request.input("id", sql.Int, userId);
    request.input("name", sql.NVarChar, name);
    request.input("phone_number", sql.NVarChar, phone_number);
    request.input("email", sql.NVarChar, email);
    if (password) request.input("password", sql.NVarChar, await bcrypt.hash(password, 10));

    await request.query(query);

    res.status(200).json({ message: "User updated successfully" });
  } catch (err) {
    console.error("Update error:", err);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Delete user
app.delete('/user/:id', async (req, res) => {
  const userId = req.params.id;

  try {
    const pool = await sql.connect(config);
    const result = await pool.request()
      .input("userId", sql.Int, userId)
      .query("DELETE FROM users WHERE id = @userId");

    if (result.rowsAffected[0] === 0) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json({ message: "User deleted successfully" });
  } catch (err) {
    console.error("Error deleting user:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// Route to get user profile by email or user ID
// GET user profile by email
app.get("/api/user-profile/:email", async (req, res) => {
  const email = req.params.email;

  try {
    await sql.connect(config);
    const result = await sql.query(`
      SELECT name, email, phone_number, role, created_at
      FROM users
      WHERE email = '${email}'
    `);

    if (result.recordset.length > 0) {
      res.json(result.recordset[0]);
    } else {
      res.status(404).json({ message: "User not found" });
    }
  } catch (err) {
    console.error("SQL error:", err);
    res.status(500).send("Server error");
  }
});

// PUT update user profile by email (no bcrypt)
app.put("/api/user-profile/update/:email", async (req, res) => {
  const { email } = req.params;
  const { name, address, phone_number, password } = req.body;

  try {
    const pool = await sql.connect(config);
    
    let updateQuery = `
      UPDATE Users
      SET 
        name = @name,
        address = @address,
        phone_number = @phone_number`;
    
    const request = pool.request()
      .input("name", sql.VarChar(100), name)
      .input("address", sql.VarChar(100), address)
      .input("phone_number", sql.VarChar(20), phone_number)
      .input("email", sql.VarChar(100), email);

    if (password && password.trim() !== "") {
      updateQuery += `, password_hash = @password`; // NOTE: your column is password_hash
      request.input("password", sql.VarChar(255), password); // Plain password
    }

    updateQuery += ` WHERE email = @email`;

    const result = await request.query(updateQuery);

    if (result.rowsAffected[0] === 0) {
      res.status(404).json({ message: "User not found" });
    } else {
      res.json({ message: "Profile updated successfully" });
    }
  } catch (err) {
    console.error("Error updating profile:", err);
    res.status(500).json({ error: "Internal server error" });
  }
});


// --- INVOICE PAGE ---
app.get("/cart/:userId", async (req, res) => {
  const userId = req.params.userId;

  try {
    await sql.connect(config);

    const result = await sql.query(`
      SELECT 
        p.name,
        p.price,
        c.quantity
      FROM Cart c
      JOIN Products p ON c.productId = p.id
      WHERE c.userId = ${userId}
    `);

    res.json(result.recordset);
  } catch (err) {
    console.error("Error loading cart:", err);
    res.status(500).send("Server error");
  }
});

// -- VIEW ORDERS PAGE ---

// Add this to your backend routes (e.g., in invoiceRoutes.js or server.js)
app.post("/save-invoice", async (req, res) => {
  const { userId, invoiceId, date, items, subtotal, tax, total } = req.body;

  try {
    const pool = await sql.connect(config);

    // Save invoice summary
    await pool.request()
      .input("userId", sql.Int, userId)
      .input("invoiceId", sql.VarChar, invoiceId)
      .input("date", sql.VarChar, date)
      .input("subtotal", sql.Decimal(10, 2), subtotal)
      .input("tax", sql.Decimal(10, 2), tax)
      .input("total", sql.Decimal(10, 2), total)
      .query(`INSERT INTO Invoices (UserId, InvoiceID, Date, Subtotal, Tax, Total)
              VALUES (@userId, @invoiceId, @date, @subtotal, @tax, @total)`);

    // Save each item
    for (const item of items) {
      await pool.request()
        .input("invoiceId", sql.VarChar, invoiceId)
        .input("itemName", sql.VarChar, item.name)
        .input("price", sql.Decimal(10, 2), item.price)
        .input("quantity", sql.Int, item.quantity)
        .input("total", sql.Decimal(10, 2), item.total)
        .query(`INSERT INTO InvoiceItems (InvoiceID, ItemName, Price, Quantity, Total)
                VALUES (@invoiceId, @itemName, @price, @quantity, @total)`);
    }

    // Clear the user's cart
    await pool.request()
      .input("userId", sql.Int, userId)
      .query(`DELETE FROM Cart WHERE UserId = @userId`);

    res.status(200).json({ message: "Invoice saved and cart cleared." });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to save invoice." });
  }
});

// Backend
app.get('/invoices/:userId', async (req, res) => {
  const { userId } = req.params;

  try {
    const pool = await sql.connect(config);

    // Get basic invoice info with user details
    const invoiceResult = await pool.request()
      .input("userId", sql.Int, userId)
      .query(`
        SELECT i.Id, i.InvoiceID, i.Date, i.Subtotal, i.Tax, i.Total,
               u.name AS CustomerName, u.email AS Email, u.phone_number AS Phone
        FROM Invoices i
        JOIN users u ON u.id = i.UserId
        WHERE i.UserId = @userId
      `);

    const invoices = invoiceResult.recordset;

    // For each invoice, get items
    for (const invoice of invoices) {
      const itemsResult = await pool.request()
        .input("invoiceID", sql.VarChar(50), invoice.InvoiceID)
        .query(`
          SELECT ItemName AS Name, Price, Quantity, Total
          FROM InvoiceItems
          WHERE InvoiceID = @invoiceID
        `);

      invoice.items = itemsResult.recordset;
    }

    res.json(invoices);
  } catch (err) {
    console.error("Error fetching invoices:", err);
    res.status(500).send("Internal Server Error");
  }
});


app.get("/user/:userId", async (req, res) => {
  const userId = req.params.userId;

  try {
    const pool = await sql.connect(config);
    const result = await pool
      .request()
      .input("userId", sql.Int, userId)
      .query("SELECT Name, Email, Phone, Address FROM Users WHERE UserId = @userId");

    if (result.recordset.length > 0) {
      res.json(result.recordset[0]);
    } else {
      res.status(404).json({ message: "User not found" });
    }
  } catch (err) {
    console.error("Error fetching user:", err);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.delete("/invoices/:invoiceId", async (req, res) => {
  const { invoiceId } = req.params;

  try {
    const pool = await sql.connect(config);

    // First delete related items
    await pool.request()
      .input("invoiceId", sql.VarChar(50), invoiceId)
      .query("DELETE FROM InvoiceItems WHERE InvoiceID = @invoiceId");

    // Then delete the invoice
    await pool.request()
      .input("invoiceId", sql.VarChar(50), invoiceId)
      .query("DELETE FROM Invoices WHERE InvoiceID = @invoiceId");

    res.json({ success: true, message: "Invoice deleted successfully" });
  } catch (err) {
    console.error("Delete failed:", err);
    res.status(500).json({ success: false, message: "Failed to delete invoice" });
  }
});


// ---ADMIN INVOICE---
app.post('/api/admin/save-invoice', async (req, res) => {
    const { invoiceID, adminName, customerName, totalAmount, items } = req.body;

    const pool = await sql.connect(config);
    const transaction = new sql.Transaction(pool);

    try {
        await transaction.begin();

        await transaction.request()
            .input('invoiceID', sql.VarChar(50), invoiceID)
            .input('adminName', sql.VarChar(100), adminName)
            .input('customerName', sql.VarChar(100), customerName)
            .input('totalAmount', sql.Decimal(10, 2), totalAmount)
            .query(`
                INSERT INTO AdminInvoices (InvoiceID, AdminName, CustomerName, TotalAmount)
                VALUES (@invoiceID, @adminName, @customerName, @totalAmount)
            `);

        for (const item of items) {
            await transaction.request()
                .input('invoiceID', sql.VarChar(50), invoiceID)
                .input('productName', sql.VarChar(100), item.product)
                .input('quantity', sql.Int, item.qty)
                .input('price', sql.Decimal(10, 2), item.price)
                .input('total', sql.Decimal(10, 2), item.total)
                .query(`
                    INSERT INTO AdminInvoiceItems (InvoiceID, ProductName, Quantity, Price, Total)
                    VALUES (@invoiceID, @productName, @quantity, @price, @total)
                `);
        }

        await transaction.commit();
        res.send({ message: "Admin invoice saved successfully." });

    } catch (err) {
        await transaction.rollback();
        res.status(500).send({ error: err.message });
    }
});

// Get saved admin invoices
app.get('/api/admin/invoices', async (req, res) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query(`
      SELECT InvoiceID, CustomerName, TotalAmount, DateCreated
      FROM AdminInvoices
      ORDER BY DateCreated DESC
    `);

    res.json(result.recordset); // this returns array of invoices
  } catch (err) {
    console.error('Error fetching invoices:', err);
    res.status(500).json({ error: 'Failed to fetch invoices' });
  }
});

// Total Sales This Month
app.get('/api/reports/sales-this-month', async (req, res) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query(`
      SELECT SUM(TotalAmount) AS totalSales
      FROM AdminInvoices
      WHERE MONTH(DateCreated) = MONTH(GETDATE())
        AND YEAR(DateCreated) = YEAR(GETDATE())
    `);
    res.json(result.recordset[0]); // { totalSales: 1234.56 }
  } catch (err) {
    console.error('Error getting monthly sales:', err);
    res.status(500).json({ error: 'Failed to fetch sales report' });
  }
});

// Top-Selling Products
app.get('/api/reports/top-products', async (req, res) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query(`
      SELECT ProductName, SUM(Quantity) AS totalSold
      FROM AdminInvoiceItems
      GROUP BY ProductName
      ORDER BY totalSold DESC
    `);
    res.json(result.recordset); // [{ ProductName: 'Pen', totalSold: 50 }, ...]
  } catch (err) {
    console.error('Error getting top products:', err);
    res.status(500).json({ error: 'Failed to fetch product report' });
  }
});

// --STAFF SALARY ---
// Example inside app.js or salaryRoutes.js
app.get('/api/salary/paid', async (req, res) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request()
      .query("SELECT * FROM StaffSalary WHERE Status = 'Paid'");
    res.json(result.recordset);
  } catch (err) {
    console.error('Error fetching paid salaries:', err);
    res.status(500).json({ error: 'Server error' });
  }
});

app.get('/api/salary/pending', async (req, res) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request()
      .query("SELECT * FROM StaffSalary WHERE Status = 'Pending'");
    res.json(result.recordset);
  } catch (err) {
    console.error('Error fetching pending salaries:', err);
    res.status(500).json({ error: 'Server error' });
  }
});


// POST /api/salary/add
app.post('/api/salary/add', async (req, res) => {
  const { StaffName, Amount, Status, DatePaid } = req.body;
  try {
    const pool = await sql.connect(config);
    await pool.request()
      .input('StaffName', sql.VarChar, StaffName)
      .input('Amount', sql.Decimal(10, 2), Amount)
      .input('Status', sql.VarChar, Status)
      .input('DatePaid', sql.DateTime, DatePaid)
      .query(`INSERT INTO StaffSalary (StaffName, Amount, Status, DatePaid) 
              VALUES (@StaffName, @Amount, @Status, @DatePaid)`);
    res.json({ success: true });
  } catch (err) {
    console.error('Insert Error:', err);
    res.status(500).json({ success: false });
  }
});











    









// --- Start the server ---
app.listen(port, () => {
  console.log(`🚀 Server running on http://localhost:${port}`);
});