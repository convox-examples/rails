class HomeController < ApplicationController
  def index
    render html: home_html.html_safe
  end

  private

  def home_html
    <<~HTML
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Convox Rails Example</title>
          <style>
              * { margin: 0; padding: 0; box-sizing: border-box; }
              body {
                  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                  line-height: 1.6;
                  color: #2D3133;
                  background: linear-gradient(135deg, #11BADF 0%, #11495A 100%);
                  min-height: 100vh;
              }
              .container {
                  max-width: 800px;
                  margin: 0 auto;
                  padding: 2rem;
              }
              header {
                  text-align: center;
                  color: #FFFFFF;
                  padding: 3rem 0;
              }
              h1 {
                  font-size: 3rem;
                  margin-bottom: 0.5rem;
                  text-shadow: 2px 2px 4px rgba(2, 38, 48, 0.3);
              }
              .subtitle {
                  font-size: 1.2rem;
                  opacity: 0.95;
                  color: #9AEDFF;
              }
              .main-content {
                  background: #FFFFFF;
                  border-radius: 12px;
                  padding: 2rem;
                  box-shadow: 0 10px 40px rgba(2, 38, 48, 0.2);
              }
              h2 {
                  color: #11495A;
                  margin-bottom: 1rem;
              }
              .stats-grid {
                  display: grid;
                  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                  gap: 1rem;
                  margin-bottom: 2rem;
              }
              .stat-card {
                  padding: 1rem;
                  background: #F7F7F7;
                  border-radius: 8px;
                  border-left: 4px solid #11BADF;
              }
              .stat-value {
                  font-size: 2rem;
                  font-weight: bold;
                  color: #11BADF;
              }
              .stat-label {
                  color: #9D9D9D;
                  font-size: 0.9rem;
              }
              .button {
                  display: inline-block;
                  padding: 0.75rem 1.5rem;
                  background: #11BADF;
                  color: #FFFFFF;
                  text-decoration: none;
                  border-radius: 6px;
                  margin: 0.5rem;
                  transition: all 0.2s;
              }
              .button:hover {
                  transform: translateY(-2px);
                  box-shadow: 0 5px 15px rgba(17, 186, 223, 0.3);
                  background: #23DEFF;
              }
              .endpoints {
                  margin-top: 2rem;
              }
              .endpoint {
                  padding: 0.75rem;
                  background: #F7F7F7;
                  border-radius: 6px;
                  margin: 0.5rem 0;
                  font-family: monospace;
              }
              footer {
                  text-align: center;
                  color: #9AEDFF;
                  padding: 2rem 0;
              }
              footer a {
                  color: #FFFFFF;
                  text-decoration: none;
              }
          </style>
      </head>
      <body>
          <div class="container">
              <header>
                  <h1>Convox Rails Example</h1>
                  <p class="subtitle">Successfully Deployed on Convox!</p>
              </header>

              <div class="main-content">
                  <h2>Application Status</h2>
                  <div class="stats-grid">
                      <div class="stat-card">
                          <div class="stat-value">✅</div>
                          <div class="stat-label">Health Status</div>
                      </div>
                      <div class="stat-card">
                          <div class="stat-value">#{User.count rescue 0}</div>
                          <div class="stat-label">Total Users</div>
                      </div>
                      <div class="stat-card">
                          <div class="stat-value">#{Rails.version}</div>
                          <div class="stat-label">Rails Version</div>
                      </div>
                      <div class="stat-card">
                          <div class="stat-value">#{ENV['APP'] || 'Local'}</div>
                          <div class="stat-label">App Name</div>
                      </div>
                  </div>

                  <h2>Available Endpoints</h2>
                  <div class="endpoints">
                      <div class="endpoint">GET /health - Health check endpoint</div>
                      <div class="endpoint">GET /api/status - System status JSON</div>
                      <div class="endpoint">GET /api/users - Users API</div>
                      <div class="endpoint">GET /api/stats - Application statistics</div>
                      <div class="endpoint">GET /users - User management interface</div>
                  </div>

                  <div style="text-align: center; margin-top: 2rem;">
                      <a href="/users" class="button">Manage Users</a>
                      <a href="/api/status" class="button">API Status</a>
                      <a href="/health" class="button">Health Check</a>
                  </div>
              </div>

              <footer>
                  <p>Powered by <a href="https://convox.com" target="_blank">Convox</a></p>
              </footer>
          </div>
      </body>
      </html>
    HTML
  end
end