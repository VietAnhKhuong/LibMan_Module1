<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.text.SimpleDateFormat, model.Reader3" %>
<%
    // Do doRegisterCard3.jsp chuyển lại khi có lỗi: thông báo lỗi (outNotification) và dữ liệu đã nhập (reader).
    // Lần vào trang đầu tiên cả hai đều chưa có.
    String outNotification = (String) request.getAttribute("outNotification");
    Reader3 reader = (Reader3) request.getAttribute("reader");
    if (reader == null) {
        reader = new Reader3();
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng kí làm thẻ bạn đọc - LibMan</title>
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

        .card {
            background: var(--paper);
            border: 1px solid var(--line);
            border-radius: 6px;
            overflow: hidden;
        }

        .card-head {
            background: var(--pine);
            color: #fff;
            padding: 18px 24px;
        }

        .card-head h1 { margin: 0; font-size: 1.35rem; font-weight: 600; }

        .card-head p { margin: 4px 0 0; font-size: .92rem; opacity: .9; }

        .card-body { padding: 8px 24px 24px; }

        .field {
            display: grid;
            grid-template-columns: 170px 1fr;
            gap: 4px 16px;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid var(--line);
        }

        .field label { font-weight: 500; }

        .field .hint { grid-column: 2; margin: 0; font-size: .85rem; color: var(--muted); }

        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="date"] {
            width: 100%;
            padding: 8px 10px;
            font: inherit;
            color: var(--ink);
            background: #fff;
            border: 1px solid var(--line);
            border-radius: 4px;
        }

        input:focus-visible,
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

        .btn-quiet {
            background: transparent;
            color: var(--pine-dark);
            border: 1px solid var(--line);
        }

        .btn-quiet:hover { background: var(--desk); }

        .notice {
            margin: 16px 0 0;
            padding: 12px 14px;
            border-radius: 4px;
            font-size: .95rem;
        }

        .notice-error { background: var(--alert-bg); color: var(--alert-ink); }

        @media (max-width: 560px) {    .field { grid-template-columns: 1fr; }
            .field .hint { grid-column: 1; }
        }
    </style>
</head>
<body>
<main class="page">
    <p class="brand">LibMan</p>

    <form class="card" method="post" action="<%= request.getContextPath() %>/view/reader/doRegisterCard3.jsp" novalidate>
        <div class="card-head">
            <h1>Đăng kí làm thẻ bạn đọc</h1>
            <p>Điền đầy đủ các ô bên dưới. Thẻ có hiệu lực từ ngày đăng kí thành công đến hết niên khóa của bạn.</p>
        </div>

        <div class="card-body">
            <% if (outNotification != null) { %>
            <div class="notice notice-error" id="outNotification" role="alert"><%= outNotification %></div>
            <% } %>

            <div class="field">
                <label for="inName">Họ tên</label>
                <input type="text" id="inName" name="inName" maxlength="255" autocomplete="name"
                       value="<%= java.util.Objects.toString(reader.getName(), "").replace("&", "&amp;").replace("<", "&lt;").replace("\"", "&quot;") %>">
            </div>
            <div class="field">
                <label for="inBirthday">Ngày sinh</label>
                <input type="date" id="inBirthday" name="inBirthday" autocomplete="bday"
                       value="<%= reader.getBirthday() == null ? "" : new SimpleDateFormat("yyyy-MM-dd").format(reader.getBirthday()) %>">
            </div>
            <div class="field">
                <label for="inAddress">Địa chỉ</label>
                <input type="text" id="inAddress" name="inAddress" maxlength="255" autocomplete="street-address"
                       value="<%= java.util.Objects.toString(reader.getAddress(), "").replace("&", "&amp;").replace("<", "&lt;").replace("\"", "&quot;") %>">
            </div>
            <div class="field">
                <label for="inEmail">Email</label>
                <input type="email" id="inEmail" name="inEmail" maxlength="255" autocomplete="email"
                       value="<%= java.util.Objects.toString(reader.getEmail(), "").replace("&", "&amp;").replace("<", "&lt;").replace("\"", "&quot;") %>">
            </div>
            <div class="field">
                <label for="inPhoneNumber">Số điện thoại</label>
                <input type="text" id="inPhoneNumber" name="inPhoneNumber" maxlength="11" inputmode="numeric" autocomplete="tel"
                       value="<%= java.util.Objects.toString(reader.getPhoneNumber(), "").replace("&", "&amp;").replace("<", "&lt;").replace("\"", "&quot;") %>">
                <p class="hint">9 đến 11 chữ số.</p>
            </div>
            <div class="field">
                <label for="inStartYear">Năm bắt đầu niên khóa</label>
                <input type="text" id="inStartYear" name="inStartYear" maxlength="4" inputmode="numeric"
                       value="<%= reader.getStartYear() == 0 ? "" : String.valueOf(reader.getStartYear()) %>">
                <p class="hint">Ví dụ: 2023</p>
            </div>
            <div class="field">
                <label for="inEndYear">Năm kết thúc niên khóa</label>
                <input type="text" id="inEndYear" name="inEndYear" maxlength="4" inputmode="numeric"
                       value="<%= reader.getEndYear() == 0 ? "" : String.valueOf(reader.getEndYear()) %>">
                <p class="hint">Ví dụ: 2027. Thẻ hết hạn vào 31/12 của năm này.</p>
            </div>
            <div class="field">
                <label for="inUsername">Tên đăng nhập</label>
                <input type="text" id="inUsername" name="inUsername" maxlength="30" autocomplete="username"
                       value="<%= java.util.Objects.toString(reader.getUsername(), "").replace("&", "&amp;").replace("<", "&lt;").replace("\"", "&quot;") %>">
                <p class="hint">4 đến 30 ký tự: chữ cái, chữ số hoặc dấu gạch dưới.</p>
            </div>
            <div class="field">
                <label for="inPassword">Mật khẩu</label>
                <input type="password" id="inPassword" name="inPassword" maxlength="72" autocomplete="new-password">
                <p class="hint">Tối thiểu 6 ký tự.</p>
            </div>
            <div class="field">
                <label for="inConfirmPassword">Xác nhận mật khẩu</label>
                <input type="password" id="inConfirmPassword" name="inConfirmPassword" maxlength="72" autocomplete="new-password">
            </div>

            <div class="actions">
                <button type="submit" class="btn" id="subAdd" name="subAdd">Đăng kí</button>
            </div>
        </div>
    </form>

    <%-- Nút quay lại nằm trong form riêng (GET) để không gửi dữ liệu form đăng kí, nhất là mật khẩu, lên địa chỉ trang --%>
    <form method="get" action="<%= request.getContextPath() %>/view/reader/ReaderMainUI3.jsp" class="actions">
        <button type="submit" class="btn btn-quiet" id="subBack" name="subBack">Về trang chủ</button>
    </form>
</main>
</body>
</html>
