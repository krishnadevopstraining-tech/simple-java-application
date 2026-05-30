# Frontend Service

Modern React 18 application with TypeScript, Tailwind CSS, and comprehensive UI features.

## Features

- **React 18**: Latest React with hooks
- **TypeScript**: Type-safe development
- **Tailwind CSS**: Utility-first CSS framework
- **Axios**: HTTP client for API communication
- **React Router**: Client-side routing
- **Responsive Design**: Mobile-friendly interface
- **Form Validation**: Built-in validation
- **Error Handling**: User-friendly error messages

## Building

```bash
cd frontend
npm install
npm run build
```

## Running Locally

```bash
cd frontend
npm install
# Set API URL (optional, defaults to http://localhost:8080)
REACT_APP_API_URL=http://localhost:8080 npm start
```

## Environment Variables

- `REACT_APP_API_URL` - Backend API URL (default: http://localhost:8080)

## Available Scripts

- `npm start` - Run development server
- `npm run build` - Create production build
- `npm test` - Run tests

## Structure

```
src/
  App.tsx       - Main application component
  index.tsx     - React DOM entry point
  index.css     - Global styles
```
