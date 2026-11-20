package dao;

import model.Reader3;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.GeneralSecurityException;
import java.security.SecureRandom;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.Base64;

public class ReaderDAO3 extends DAO3 {

    public ReaderDAO3() {
        super();
    }

    /** Kiểm tra tên đăng nhập hoặc email đã có trong hệ thống chưa. */
    public boolean checkMemberExist(String username, String email) {
        String sql = "SELECT 1 FROM tblMember3 WHERE username = ? OR email = ? LIMIT 1";
        synchronized (DAO3.class) { // kết nối dùng chung nên mỗi lần truy cập CSDL xếp hàng lần lượt
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setString(2, email);
                try (ResultSet rs = ps.executeQuery()) {
                    return rs.next();
                }
            } catch (SQLException e) {
                throw new IllegalStateException("Lỗi khi kiểm tra thành viên: " + e.getMessage(), e);
            }
        }
    }

    /**
     * Lưu bạn đọc mới: gán ngày cấp thẻ (hôm nay) và ngày hết hạn (31/12 của năm kết thúc niên khóa),
     * ghi tblMember3 rồi tblReader3 trong cùng một transaction. Trả về false nếu không lưu được
     * (ví dụ tên đăng nhập hoặc email vừa bị người khác đăng kí).
     */
    public boolean addReader(Reader3 reader) {
        reader.setCardIssuanceDate(java.sql.Date.valueOf(LocalDate.now()));
        reader.setCardExpirationDate(java.sql.Date.valueOf(LocalDate.of(reader.getEndYear(), 12, 31)));

        String sqlMember = "INSERT INTO tblMember3 "
                + "(name, username, password, birthday, address, email, phoneNumber) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        String sqlReader = "INSERT INTO tblReader3 "
                + "(tblMember3id, startYear, endYear, cardIssuanceDate, cardExpirationDate) VALUES (?, ?, ?, ?, ?)";

        synchronized (DAO3.class) {
            try {
                // Băm mật khẩu bằng PBKDF2 (có sẵn trong JDK), lưu dạng iterations:salt:hash (Base64).
                // Đối tượng reader vẫn giữ mật khẩu gốc, chỉ cột password trong CSDL là chuỗi đã băm.
                int iterations = 120000;
                byte[] salt = new byte[16];
                new SecureRandom().nextBytes(salt);
                byte[] hash = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
                        .generateSecret(new PBEKeySpec(reader.getPassword().toCharArray(), salt, iterations, 256))
                        .getEncoded();
                String storedPassword = iterations + ":" + Base64.getEncoder().encodeToString(salt)
                        + ":" + Base64.getEncoder().encodeToString(hash);

                con.setAutoCommit(false);
                try (PreparedStatement psMember = con.prepareStatement(sqlMember, Statement.RETURN_GENERATED_KEYS)) {
                    psMember.setString(1, reader.getName());
                    psMember.setString(2, reader.getUsername());
                    psMember.setString(3, storedPassword);
                    psMember.setDate(4, new java.sql.Date(reader.getBirthday().getTime()));
                    psMember.setString(5, reader.getAddress());
                    psMember.setString(6, reader.getEmail());
                    psMember.setString(7, reader.getPhoneNumber());
                    psMember.executeUpdate();

                    try (ResultSet keys = psMember.getGeneratedKeys()) {
                        if (!keys.next()) {
                            con.rollback();
                            return false;
                        }
                        reader.setId(keys.getInt(1));
                    }
                }
                try (PreparedStatement psReader = con.prepareStatement(sqlReader)) {
                    psReader.setInt(1, reader.getId());
                    psReader.setInt(2, reader.getStartYear());
                    psReader.setInt(3, reader.getEndYear());
                    psReader.setDate(4, new java.sql.Date(reader.getCardIssuanceDate().getTime()));
                    psReader.setDate(5, new java.sql.Date(reader.getCardExpirationDate().getTime()));
                    psReader.executeUpdate();
                }
                con.commit();
                return true;
            } catch (SQLException | GeneralSecurityException e) {
                try {
                    con.rollback();
                } catch (SQLException ignored) {
                    // kết nối đã hỏng, DAO3() sẽ mở lại ở lần gọi sau
                }
                return false;
            } finally {
                try {
                    con.setAutoCommit(true);
                } catch (SQLException ignored) {
                    // như trên
                }
            }
        }
    }
}
