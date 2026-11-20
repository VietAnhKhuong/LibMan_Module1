<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDate, java.time.format.DateTimeParseException, java.util.Date, dao.ReaderDAO3, model.Reader3" %>
<%
    request.setCharacterEncoding("UTF-8");

    // Chỉ nhận dữ liệu do nút Đăng kí (subAdd) của RegisterCardUI3 gửi lên
    if (!"POST".equals(request.getMethod()) || request.getParameter("subAdd") == null) {
        response.sendRedirect(request.getContextPath() + "/view/reader/RegisterCardUI3.jsp");
        return;
    }

    // Đóng gói dữ liệu form vào Reader3
    Reader3 reader = new Reader3();
    reader.setName(request.getParameter("inName").trim());
    reader.setAddress(request.getParameter("inAddress").trim());
    reader.setEmail(request.getParameter("inEmail").trim());
    reader.setPhoneNumber(request.getParameter("inPhoneNumber").trim());
    reader.setUsername(request.getParameter("inUsername").trim());
    reader.setPassword(request.getParameter("inPassword"));

    // Bước 6: kiểm tra thông tin nhập. Lỗi đầu tiên gặp phải được đặt vào outNotification
    // để RegisterCardUI3 hiển thị.
    if (reader.getName().isEmpty() || reader.getAddress().isEmpty() || reader.getEmail().isEmpty()
            || reader.getPhoneNumber().isEmpty() || reader.getUsername().isEmpty() || reader.getPassword().isEmpty()
            || request.getParameter("inConfirmPassword").isEmpty()
            || request.getParameter("inBirthday").trim().isEmpty()
            || request.getParameter("inStartYear").trim().isEmpty()
            || request.getParameter("inEndYear").trim().isEmpty()) {
        request.setAttribute("outNotification", "Vui lòng nhập đầy đủ tất cả các ô.");
    } else {
        try {
            reader.setBirthday(java.sql.Date.valueOf(LocalDate.parse(request.getParameter("inBirthday").trim())));
        } catch (DateTimeParseException e) {
            request.setAttribute("outNotification", "Ngày sinh không hợp lệ.");
        }
        try {
            reader.setStartYear(Integer.parseInt(request.getParameter("inStartYear").trim()));
            reader.setEndYear(Integer.parseInt(request.getParameter("inEndYear").trim()));
        } catch (NumberFormatException e) {
            request.setAttribute("outNotification", "Năm bắt đầu và năm kết thúc niên khóa phải là số có 4 chữ số.");
        }
    }
    if (request.getAttribute("outNotification") == null) {
        if (reader.getBirthday().after(new Date())) {
            request.setAttribute("outNotification", "Ngày sinh không được sau ngày hôm nay.");
        } else if (!reader.getEmail().matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            request.setAttribute("outNotification", "Email không đúng định dạng.");
        } else if (!reader.getPhoneNumber().matches("^\\d{9,11}$")) {
            request.setAttribute("outNotification", "Số điện thoại phải gồm 9 đến 11 chữ số.");
        } else if (reader.getStartYear() < 1900 || reader.getStartYear() > 9999
                || reader.getEndYear() < 1900 || reader.getEndYear() > 9999) {
            request.setAttribute("outNotification", "Năm bắt đầu và năm kết thúc niên khóa phải là số có 4 chữ số.");
        } else if (reader.getEndYear() <= reader.getStartYear()) {
            request.setAttribute("outNotification", "Năm kết thúc niên khóa phải lớn hơn năm bắt đầu.");
        } else if (reader.getEndYear() - reader.getStartYear() > 10) {
            request.setAttribute("outNotification", "Niên khóa dài tối đa 10 năm.");
        } else if (reader.getStartYear() > LocalDate.now().getYear()) {
            request.setAttribute("outNotification", "Năm bắt đầu niên khóa không được sau năm hiện tại.");
        } else if (reader.getEndYear() < LocalDate.now().getYear()) {
            request.setAttribute("outNotification", "Niên khóa đã kết thúc, không thể đăng kí thẻ.");
        } else if (!reader.getUsername().matches("^\\w{4,30}$")) {
            request.setAttribute("outNotification", "Tên đăng nhập gồm 4 đến 30 ký tự: chữ cái, chữ số hoặc dấu gạch dưới.");
        } else if (reader.getPassword().length() < 6) {
            request.setAttribute("outNotification", "Mật khẩu phải có ít nhất 6 ký tự.");
        } else if (!reader.getPassword().equals(request.getParameter("inConfirmPassword"))) {
            request.setAttribute("outNotification", "Mật khẩu và xác nhận mật khẩu không khớp.");
        }
    }

    // Bước 7 đến 17: kiểm tra tên đăng nhập, email đã tồn tại chưa rồi lưu bạn đọc
    if (request.getAttribute("outNotification") == null) {
        try {
            if ((new ReaderDAO3()).checkMemberExist(reader.getUsername(), reader.getEmail())) {
                request.setAttribute("outNotification", "Tên đăng nhập hoặc email đã tồn tại trong hệ thống.");
            } else if ((new ReaderDAO3()).addReader(reader)) {
                // Bước 18 đến 21: thông báo thành công rồi quay về trang chủ.
                // Redirect (thay vì in thẳng trang kết quả) để F5 không gửi lại form.
                session.setAttribute("flashMessage", "Đăng kí làm thẻ bạn đọc thành công.");
                response.sendRedirect(request.getContextPath() + "/view/reader/ReaderMainUI3.jsp");
                return;
            } else {
                request.setAttribute("outNotification",
                        "Chưa lưu được thẻ bạn đọc. Tên đăng nhập hoặc email có thể vừa được đăng kí, vui lòng thử lại.");
            }
        } catch (IllegalStateException e) {
            application.log("doRegisterCard3: lỗi CSDL", e);
            request.setAttribute("outNotification", "Hệ thống đang gặp sự cố, vui lòng thử lại sau.");
        }
    }

    // Có lỗi: quay lại form kèm thông báo và dữ liệu đã nhập (không kèm mật khẩu)
    reader.setPassword(null);
    request.setAttribute("reader", reader);
    request.getRequestDispatcher("/view/reader/RegisterCardUI3.jsp").forward(request, response);
%>
