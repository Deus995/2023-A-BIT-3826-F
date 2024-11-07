<?php
include 'config.php';
session_start();

if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

$user_id = $_SESSION['user_id'];
$success = $error = '';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $recipient_email = $_POST['recipient_email'];
    $amount = $_POST['amount'];
    $description = $_POST['description'];

    // Validate the recipient exists
    $stmt = $conn->prepare("SELECT id, balance FROM users WHERE email = ?");
    $stmt->bind_param("s", $recipient_email);
    $stmt->execute();
    $result = $stmt->get_result();
    $recipient = $result->fetch_assoc();

    if ($recipient) {
        $recipient_id = $recipient['id'];

        // Validate the user has sufficient balance
        $stmt = $conn->prepare("SELECT balance FROM users WHERE id = ?");
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $result = $stmt->get_result();
        $user = $result->fetch_assoc();

        if ($user && $user['balance'] >= $amount) {
            // Deduct amount from sender
            $new_sender_balance = $user['balance'] - $amount;
            $stmt = $conn->prepare("UPDATE users SET balance = ? WHERE id = ?");
            $stmt->bind_param("di", $new_sender_balance, $user_id);
            $stmt->execute();

            // Add amount to recipient
            $new_recipient_balance = $recipient['balance'] + $amount;
            $stmt = $conn->prepare("UPDATE users SET balance = ? WHERE id = ?");
            $stmt->bind_param("di", $new_recipient_balance, $recipient_id);
            $stmt->execute();

            // Record the transaction for sender
            $stmt = $conn->prepare("INSERT INTO transactions (user_id, recipient_id, type, amount, description, status) VALUES (?, ?, 'debit', ?, ?, 'completed')");
            $stmt->bind_param("iids", $user_id, $recipient_id, $amount, $description);
            $stmt->execute();

            // Record the transaction for recipient
            $stmt = $conn->prepare("INSERT INTO transactions (user_id, recipient_id, type, amount, description, status) VALUES (?, ?, 'credit', ?, ?, 'completed')");
            $stmt->bind_param("iids", $recipient_id, $user_id, $amount, $description);
            $stmt->execute();

            $success = "Payment of $amount sent to $recipient_email successfully!";
        } 
    } else {
        $error = "Recipient not found. Please check the email.";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swift Pay - Make a Payment</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h2 class="mt-5">Make a Payment</h2>
        <?php if ($success) echo "<p class='text-success'>$success</p>"; ?>
        <?php if ($error) echo "<p class='text-danger'>$error</p>"; ?>
        <form method="post">
            <div class="form-group">
                <label for="recipient_email">Recipient's Email:</label>
                <input type="email" class="form-control" id="recipient_email" name="recipient_email" required>
            </div>
            <div class="form-group">
                <label for="amount">Amount:</label>
                <input type="number" class="form-control" id="amount" name="amount" step="0.01" required>
            </div>
            <div class="form-group">
                <label for="description">Description:</label>
                <input type="text" class="form-control" id="description" name="description" required>
            </div>
            <button type="submit" class="btn btn-primary">Send Payment</button>
        </form>
        <a href="dashboard.php" class="btn btn-link mt-3">Back to Dashboard</a>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
