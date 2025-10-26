# Rails Marketplace API

<p align="left">
  <a href="https://www.ruby-lang.org"><img src="https://img.shields.io/badge/Ruby-3.3.3-CC342D?logo=ruby&logoColor=white" alt="Ruby"></a>
  <a href="https://rubyonrails.org"><img src="https://img.shields.io/badge/Rails-8.0.0-D30001?logo=rubyonrails&logoColor=white" alt="Rails 8.0.0"></a>
  <a href="https://github.com/simplecov-ruby/simplecov"><img src="https://img.shields.io/badge/Code%20Coverage-100%25-brightgreen" alt="SimpleCov Coverage"></a>
</p>

RESTful JSON API built with Ruby on Rails 8, written using Test-Driven Development (TDD) with RSpec

Based on the book [API on Rails 6 by Alexandre Rousseau](https://leanpub.com/apionrails6/), modernized with Rails 8 conventions, PostgreSQL database support, full RSpec test coverage.

---

## Deployment

The API is deployed on Render using a containerized Docker environment with PostgreSQL:

- **Live Base URL**: [https://rails-api-rspec.onrender.com/api/v1](https://rails-api-rspec.onrender.com/api/v1)
- **Demo Accounts**:
  - `demo.user1@marketplace.com` / `password123`
  - `demo.user2@marketplace.com` / `password123`
  - `demo.user3@marketplace.com` / `password123`

---

## Tech Stack

- **Ruby**: `3.3.3` (managed via `mise` and `.ruby-version`)
- **Framework**: Ruby on Rails `8.0` (API-only mode)
- **Database**: PostgreSQL (`gem 'pg', '~> 1.5'`)
- **Authentication**: Stateless JSON Web Tokens (JWT) with Bearer token prefix support
- **Serialization**: `jsonapi-serializer` conforming to the [JSON:API](https://jsonapi.org) specification
- **Testing**: RSpec 3.13, FactoryBot, Faker, SimpleCov
- **Code Quality**: RuboCop (`rubocop-rails-omakase`), Lefthook pre-commit git hooks
- **Performance & Caching**: Fragment caching with `cache_options`, Bullet N+1 query detection, Kaminari pagination
- **Deployment**: Dockerfile, `.dockerignore`

---

## Getting Started

### 1. Prerequisites
Ensure you have `mise` installed or your preferred Ruby version manager:
```bash
mise install
```

### 2. Install Dependencies
```bash
bundle install
```

### 3. Database Setup & Seeding
```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

Demo accounts created by seed:
- `demo.user1@marketplace.com` / `password123`
- `demo.user2@marketplace.com` / `password123`
- `demo.user3@marketplace.com` / `password123`

### 4. Run Tests & Coverage
```bash
bundle exec rspec
```
Code coverage report will be automatically generated at `coverage/index.html`.

### 5. Run Linter
```bash
bundle exec rubocop
```

---

## API Endpoints

All endpoints are scoped under `/api/v1` and speak JSON / JSON:API format:

| Method | Endpoint | Description | Auth Required |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/v1/tokens` | Authenticate user & obtain JWT | No |
| `GET` | `/api/v1/users/:id` | Fetch user profile | No |
| `POST` | `/api/v1/users` | Register new user account | No |
| `PATCH` | `/api/v1/users/:id` | Update user credentials | Yes (Owner) |
| `DELETE` | `/api/v1/users/:id` | Delete user account | Yes (Owner) |
| `GET` | `/api/v1/products` | List products (with pagination & filters) | No |
| `GET` | `/api/v1/products/:id` | Fetch single product with seller info | No |
| `POST` | `/api/v1/products` | Create new product listing | Yes |
| `PATCH` | `/api/v1/products/:id` | Update product details | Yes (Owner) |
| `DELETE` | `/api/v1/products/:id` | Delete product listing | Yes (Owner) |
| `GET` | `/api/v1/orders` | List user orders (paginated) | Yes |
| `GET` | `/api/v1/orders/:id` | Show single order details | Yes (Owner) |
| `POST` | `/api/v1/orders` | Place order & calculate total | Yes |

---

## Testing with cURL

Commands can be run either against local server (`http://localhost:3000`) or production (`https://rails-api-rspec.onrender.com`):

### Obtain Token:
```bash
curl -X POST https://rails-api-rspec.onrender.com/api/v1/tokens \
  -H "Content-Type: application/json" \
  -d '{"user": {"email": "demo.user1@marketplace.com", "password": "password123"}}'
```

### Fetch Paginated Products:
```bash
curl -H "Accept: application/json" "https://rails-api-rspec.onrender.com/api/v1/products?page=1&per_page=10"
```

### Place Order:
```bash
curl -X POST https://rails-api-rspec.onrender.com/api/v1/orders \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <YOUR_JWT_TOKEN>" \
  -d '{"order": {"product_ids_and_quantities": [{"product_id": 1, "quantity": 2}]}}'
```
