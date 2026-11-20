<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>LibMan - Thư viện</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&display=swap">
    <style>
        :root {
            --ink: #17212b;
            --muted: #5d6b78;
            --paper: #ffffff;
            --desk: #e9eef0;
            --pine: #1d5c4c;
            --pine-dark: #134234;
            --line: #c9d3d8;
            --alert-bg: #fdecea;
            --alert-ink: #8a1f17;
            --ok-bg: #e4f4ec;
            --ok-ink: #14583c;
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            min-height: 100vh;
            background: var(--desk);
            color: var(--ink);
            font-family: "Be Vietnam Pro", "Segoe UI", system-ui, -apple-system, sans-serif;
            font-size: 16px;
            line-height: 1.5;
        }

        .page {
            max-width: 640px;
            margin: 0 auto;
            padding: 40px 20px 64px;
        }

        .brand {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--pine-dark);
            margin: 0 0 28px;
        }

        .btn:focus-visible {
            outline: 3px solid #7fb8a8;
            outline-offset: 1px;
        }

        .actions { margin-top: 24px; display: flex; gap: 12px; align-items: center; }

        .btn {
            display: inline-block;
            padding: 10px 22px;
            font: inherit;
            font-weight: 600;
            color: #fff;
            background: var(--pine);
            border: 0;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
        }

        .btn:hover { background: var(--pine-dark); }

        .notice {
            margin: 16px 0 0;
            padding: 12px 14px;
            border-radius: 4px;
            font-size: .95rem;
        }

        .notice-success { background: var(--ok-bg); color: var(--ok-ink); display: flex; justify-content: space-between; align-items: center; gap: 12px; }

        .notice-success .btn { padding: 4px 14px; }

        .lead { color: var(--muted); max-width: 52ch; }
    </style>
</head>
<body>
<main class="page">
    <p class="brand">LibMan</p>

    <%-- Thông báo một lần do doRegisterCard3.jsp đặt vào session sau khi đăng kí thành công --%>
    <% if (session.getAttribute("flashMessage") != null) { %>
    <div class="notice notice-success" id="flash" role="status">
        <span><%= session.getAttribute("flashMessage") %></span>
        <form method="get" action="<%= request.getContextPath() %>/view/reader/ReaderMainUI3.jsp">
            <button type="submit" class="btn">OK</button>
        </form>
    </div>
    <% session.removeAttribute("flashMessage"); } %>

    <h1>Thư viện trường đại học</h1>
    <p class="lead">Chưa có thẻ bạn đọc? Đăng kí trực tuyến để mượn tài liệu và tra cứu thông tin tài liệu của thư viện.</p>

    <form method="get" action="<%= request.getContextPath() %>/view/reader/RegisterCardUI3.jsp" class="actions">
        <button type="submit" class="btn" id="subRegisterCard" name="subRegisterCard">Đăng kí làm thẻ bạn đọc</button>
    </form>
</main>
</body>
</html>
