# Netlify Deployment Guide

## ⚡ Quick Deploy to Netlify

This Flutter web app includes **pre-built files** for instant deployment on Netlify (no build step needed!).

### Option 1: One-Click Deploy via Netlify UI (RECOMMENDED ⭐)

1. Go to [Netlify](https://app.netlify.com)
2. Click **"Add new site"** → **"Import an existing project"**
3. Choose **GitHub** and select **`AI-Platform`** repository
4. ✅ Done! Netlify automatically reads `netlify.toml` and deploys
5. Your app goes live in **~30 seconds** ⚡

### Option 2: Deploy via Netlify CLI

```bash
npm install -g netlify-cli
netlify deploy --prod --dir=build/web
```

### Option 3: Drag & Drop Deploy (Fastest!)

1. Go to [netlify.com/drop](https://app.netlify.com/drop)
2. Drag the `build/web` folder
3. Your app is live instantly!

## Configuration Details

- **Deploy Directory:** `build/web` (pre-built Flutter web app)
- **No Build Step Needed:** ⚡ Instant deployment!
- **File Size:** ~9.5 MB (fully optimized)
- **Environment:** Production-ready with tree-shaking & minification

### What's in netlify.toml

✅ **Pre-built Files** - Uses `build/web` folder (no build on Netlify)  
✅ **SPA Routing** - All routes redirect to index.html for Flutter routing  
✅ **Security Headers** - XSS, clickjacking, and content-type protections  
✅ **Asset Caching** - JS and WASM files cached for 1 year  
✅ **Automatic Deployments** - Push to `master` = auto-deploy  

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Blank page after deploy | Check browser console (F12) for Firebase errors |
| Firebase not initializing | Verify `lib/firebase_options.dart` has correct config |
| 404 on routes | SPA routing in `netlify.toml` should handle all routes |
| App not loading | Clear browser cache (Ctrl+Shift+Delete) and reload |

## Next Steps

1. ✅ Deploy to Netlify (see options above)
2. ✅ Share deployed URL with your guide
3. ✅ Test all features in the demo
4. Optional: Add custom domain in Netlify settings

## Auto-Deploy on Push

Once connected to Netlify:
1. Any push to `master` branch = automatic deployment
2. Build happens in seconds (just serves pre-built files)
3. Deploy preview available for pull requests

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
