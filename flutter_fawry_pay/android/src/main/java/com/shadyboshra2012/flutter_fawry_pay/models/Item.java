package com.shadyboshra2012.flutter_fawry_pay.models;

import com.emeint.android.fawryplugin.Plugininterfacing.PayableItem;

import java.io.Serializable;


public class Item implements PayableItem, Serializable {
    private String sku;
    private String description;
    private String qty;
    private String price;
    private String originalPrice = null;
    private String height = null;
    private String length = null;
    private String weight = null;
    private String width = null;
    private String variantCode = null;
    private String[] reservationCodes;
    private String earningRuleID = null;

    public Item() {
    }

    public Item(String productSKU, String description, String quantity, String price) {
        setSku(productSKU);
        setDescription(description);
        setQty(quantity);
        setPrice(price);
    }

    public String getHeight() {
        return height;
    }

    public void setHeight(String height) {
        this.height = height;
    }

    public String getLength() {
        return length;
    }

    public void setLength(String length) {
        this.length = length;
    }

    public String getVariantCode() {
        return variantCode;
    }

    public void setVariantCode(String variantCode) {
        this.variantCode = variantCode;
    }

    public String getEarningRuleID() {
        return earningRuleID;
    }

    public void setEarningRuleID(String earningRuleID) {
        this.earningRuleID = earningRuleID;
    }

    public String getWeight() {
        return weight;
    }

    public void setWeight(String weight) {
        this.weight = weight;
    }

    public String[] getReservationCodes() {
        return reservationCodes;
    }

    public void setReservationCodes(String[] reservationCodes) {
        this.reservationCodes = reservationCodes;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public String getQty() {
        return qty;
    }

    public void setQty(String qty) {
        this.qty = qty;
    }


    public String getWidth() {
        return width;
    }

    public void setWidth(String width) {
        this.width = width;
    }

    public String getOriginalPrice() {
        return originalPrice;
    }

    public void setOriginalPrice(String originalPrice) {
        this.originalPrice = originalPrice;
    }


    @Override
    public String getFawryItemOriginalPrice() {
        return originalPrice;
    }


    @Override
    public String getFawryItemDescription() {
        return description;
    }

    @Override
    public String getFawryItemSKU() {
        return sku;
    }

    @Override
    public String getFawryItemPrice() {
        return price;
    }

    @Override
    public String getFawryItemQuantity() {
        return qty;
    }

    @Override
    public String getFawryItemVariantCode() {
        return variantCode;
    }

    @Override
    public String[] getFawryItemReservationCodes() {
        return reservationCodes;
    }

    @Override
    public String getFawryItemHeight() {
        return height;
    }

    @Override
    public String getFawryItemLength() {
        return length;
    }

    @Override
    public String getFawryItemWeight() {
        return weight;
    }

    @Override
    public String getFawryItemEarningRuleID() {
        return earningRuleID;
    }

    @Override
    public String getFawryItemWidth() {
        return width;
    }


}
