package model;

import java.util.Date;

/**
 * Bạn đọc (sinh viên). Kế thừa Member3 nên không có id riêng:
 * khóa chính của tblReader3 chính là tblMember3id.
 * Thẻ hết hạn khi niên khóa (startYear đến endYear) kết thúc.
 */
public class Reader3 extends Member3 {
    private Date cardIssuanceDate;
    private Date cardExpirationDate;
    private int startYear;
    private int endYear;

    public Reader3() {
        super();
    }

    public Date getCardIssuanceDate() { return cardIssuanceDate; }
    public void setCardIssuanceDate(Date cardIssuanceDate) { this.cardIssuanceDate = cardIssuanceDate; }

    public Date getCardExpirationDate() { return cardExpirationDate; }
    public void setCardExpirationDate(Date cardExpirationDate) { this.cardExpirationDate = cardExpirationDate; }

    public int getStartYear() { return startYear; }
    public void setStartYear(int startYear) { this.startYear = startYear; }

    public int getEndYear() { return endYear; }
    public void setEndYear(int endYear) { this.endYear = endYear; }
}
