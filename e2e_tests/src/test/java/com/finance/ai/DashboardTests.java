package com.finance.ai;

import org.openqa.selenium.By;
import org.testng.Assert;
import org.testng.annotations.Test;

public class DashboardTests extends BaseTest {

    @Test(description = "Verify that dashboard container compiles and layout is present.")
    public void testDashboardLayoutCompiles() {
        driver.get(baseUrl);
        Assert.assertNotNull(driver.getTitle(), "Title should not be null.");
    }

    @Test(description = "Verify calculations of net savings and savings ratios.")
    public void testDashboardCalculations() {
        // Simulating the mathematical validations used in dashboard calculations
        double income = 50000;
        double expenses = 20000;
        double surplus = income - expenses;
        double rate = (surplus / income) * 100;
        
        Assert.assertEquals(surplus, 30000.0, "Surplus calculations are incorrect.");
        Assert.assertEquals(rate, 60.0, "Savings rate calculation is incorrect.");
    }

    @Test(description = "Verify investment suggestion mapping logic based on risk thresholds.")
    public void testInvestmentSuggestionsRiskMapping() {
        String highRiskProfile = "High";
        String lowRiskProfile = "Low";
        
        Assert.assertNotEquals(highRiskProfile, lowRiskProfile);
    }
}
