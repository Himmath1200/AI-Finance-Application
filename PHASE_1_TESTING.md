# 🧪 Phase 1: Demo Testing Guide

Quick manual testing checklist for your AI Finance Platform demo.

## 🚀 Before You Start

1. Open the deployed app: `https://your-app-name.netlify.app`
2. Have test credentials ready (or create a new account during demo)

## ✅ Test Sequence (3-5 minutes)

### 1. Signup/Registration (Optional - use existing account)
```
If creating new account:
- Click "Create Account"
- Enter email: test@example.com
- Enter password: TestPass123!
- Click "Sign up"
- Dashboard should load ✓
```

### 2. Login Flow
```
- Go to login screen
- Enter credentials
- Click "Login"
- Dashboard appears ✓
- Profile shows correct name ✓
```

### 3. Dashboard Overview
```
Expected to see:
✓ Profile section with user name
✓ Financial overview card
✓ Charts/graphs (if data exists)
✓ Expense tracker
✓ Savings progress
✓ Investment recommendations section
✓ Risk assessment score
```

### 4. Navigation
```
Test menu/navigation:
✓ Dashboard - home screen
✓ Profile - view/edit profile
✓ Settings - theme toggle (light/dark)
✓ Logout button works
✓ Redirects to login after logout
```

### 5. Data Entry (Finance Form)
```
If finance form is available:
✓ Fill in financial data
✓ Add expenses/income
✓ Submit form
✓ Data saves ✓
✓ Updates dashboard
```

### 6. Firebase Integration Check
```
Open browser DevTools (F12):
- Console tab: Should NOT show Firebase errors
- Should see successful initialization
- No 404 or CORS errors
```

## 🎯 Demo Script (2-3 min version)

1. **Show Login** → Log in to demo account
2. **Show Dashboard** → Highlight key features
   - Profile section
   - Financial overview
   - Charts
   - Risk assessment
3. **Show Navigation** → Demo menu items
4. **Show Theme Toggle** → Switch light/dark mode
5. **Show Responsive** → Resize browser to show mobile layout
6. **Show Code** → Open GitHub repo to showcase code quality

## 📋 Expected Results

| Feature | Status | Notes |
|---------|--------|-------|
| Login/Signup | ✅ Works | Firebase Auth |
| Dashboard Load | ✅ Works | Data from Firebase |
| Charts Render | ✅ Works | FL Chart library |
| Navigation | ✅ Works | Flutter routing |
| Theme Toggle | ✅ Works | Provider state |
| Responsive | ✅ Works | Mobile-friendly |

## ❌ Troubleshooting

| Issue | Solution |
|-------|----------|
| Blank screen | Press F5 to refresh |
| Login fails | Check Firebase Auth in console |
| No data shown | Create financial data first |
| Charts don't show | Data might be empty - add expense |

## 📱 Browser Support

✅ Chrome (recommended)  
✅ Firefox  
✅ Edge  
✅ Safari  

## 💡 Tips for Demo

- Pre-login to an account before demo starts
- Have test data ready to show
- Point out responsive design (resize window)
- Mention tech stack: Flutter, Firebase, Provider
- Show code structure on GitHub repo

---

**Demo Ready!** Your app is production-ready for presentation. 🎉
