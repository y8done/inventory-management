<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Clinic Inventory - Login</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            height: 100vh; 
            background-color: #f4f7f6; 
            margin: 0;
        }
        .login-box { 
            background: white; 
            padding: 40px; 
            border-radius: 10px; 
            box-shadow: 0 8px 16px rgba(0,0,0,0.1); 
            width: 320px; 
            text-align: center; 
        }
        .login-box h2 {
            margin-top: 0;
            color: #333;
        }
        .field { 
            width: 100%; 
            padding: 12px; 
            margin: 10px 0 20px 0; 
            box-sizing: border-box; 
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .btn { 
            width: 100%; 
            padding: 12px; 
            background: #2c3e50; 
            color: white; 
            border: none; 
            border-radius: 5px; 
            cursor: pointer; 
            font-size: 16px;
            font-weight: bold;
        }
        .btn:hover { 
            background: #1a252f; 
        }
    </style>
</head>
<body>

    <div class="login-box">
        <h2>System Login</h2>
        
        <form action="LoginServlet" method="POST">
            <input type="text" name="username" class="field" placeholder="Username" required>
            
            <input type="password" name="password" class="field" placeholder="Password" required>
            
            <button type="submit" class="btn">Login</button>
        </form>
    </div>

</body>
</html>