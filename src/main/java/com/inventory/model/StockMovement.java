package com.inventory.model;

import java.sql.Date;

public class StockMovement {
	private int movementId;
	private int productId;
	private String productName;
	private String movementType;
	private int quantity;
	private Date movementDate;
	private String remarks;
	public StockMovement()
	{
		
	}
	public int getMovementId() {
		return movementId;
	}
	public void setMovementId(int movementId) {
		this.movementId = movementId;
	}
	public int getProductId() {
		return productId;
	}
	public void setProductId(int productId) {
		this.productId = productId;
	}
	public String getProductName() {
		return productName;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public String getMovementType() {
		return movementType;
	}
	public void setMovementType(String movementType) {
		this.movementType = movementType;
	}
	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	public Date getMovementDate() {
		return movementDate;
	}
	public void setMovementDate(Date movementDate) {
		this.movementDate = movementDate;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public StockMovement(int movementId, int productId, String productName, String movementType, int quantity,
			Date movementDate, String remarks) {
		super();
		this.movementId = movementId;
		this.productId = productId;
		this.productName = productName;
		this.movementType = movementType;
		this.quantity = quantity;
		this.movementDate = movementDate;
		this.remarks = remarks;
	}
	
	
	
}
