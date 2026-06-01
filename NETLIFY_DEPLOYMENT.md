# Netlify Deployment Guide

## Quick Deploy to Netlify

This Flutter web app is configured for easy deployment on Netlify.

### Option 1: Deploy via Netlify CLI (Recommended)

1. **Install Netlify CLI:**
   ```bash
   npm install -g netlify-cli
   ```

2. **Build the web app:**
   ```bash
   flutter build web --release
   ```

3. **Deploy to Netlify:**
   ```bash
   netlify deploy --prod --dir=build/web
   ```

4. **Authenticate when prompted with your Netlify account**

### Option 2: Deploy via Netlify UI (Easiest)

1. Go to [Netlify](https://app.netlify.com)
2. Click **"Add new site"** → **"Import an existing project"**
3. Choose GitHub and select **`AI-Platform`** repository
4. Configure build settings:
   - **Build command:** `flutter build web --release`
   - **Publish directory:** `build/web`
   - **Environment variables:** Leave empty (no .env needed for web)
5. Click **"Deploy"**

### Option 3: Connect Repository for Auto-Deployment

1. Go to [Netlify](https://app.netlify.com)
2. Click **"Add new site"** → **"Import an existing project"**
3. Choose GitHub and select **`AI-Platform`** repository
4. Netlify will automatically read `netlify.toml` configuration
5. Push changes to `master` branch to auto-deploy

## Configuration Details

- **Build Command:** `flutter build web --release`
- **Publish Directory:** `build/web`
- **Environment:** Production-ready optimized build

### Features Configured in netlify.toml

✅ **SPA Routing** - All routes redirect to index.html for Flutter routing  
✅ **Security Headers** - XSS, clickjacking, and content-type protections  
✅ **Asset Caching** - JS and WASM files cached for 1 year  
✅ **Optimized Build** - Release build with tree-shaking and minification  

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Build fails | Ensure Flutter is installed and in PATH |
| UI not loading | Check browser console for Firebase initialization errors |
| Blank screen | Verify Firebase credentials in lib/firebase_options.dart |
| 404 errors on routes | SPA routing configured in netlify.toml should handle all routes |

## Demo URL

After deployment, your app will be available at:
- `https://your-netlify-domain.netlify.app`

## Next Steps

1. Test the deployed app
2. Share the Netlify URL with your guide for demo
3. Add custom domain (optional)
4. Set up monitoring and error tracking

## Firebase Configuration

The web app uses hardcoded Firebase options in `lib/firebase_options.dart`. These are safe for public display as they only contain public configuration (no API keys).

To modify Firebase settings:
1. Edit `lib/firebase_options.dart`
2. Update web configuration section
3. Rebuild: `flutter build web --release`
4. Redeploy to Netlify

---

**Status:** ✅ Ready for Netlify deployment  
**Last Updated:** June 1, 2026
