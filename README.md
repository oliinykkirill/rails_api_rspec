# Marketplace API

A production-ready RESTful JSON API built with Ruby on Rails 8, written using Test-Driven Development (TDD) with RSpec, FactoryBot, and SimpleCov.

Architectural patterns and domain logic are based on the book [API on Rails 6 by Alexandre Rousseau](https://leanpub.com/apionrails6/), modernized with modern Rails 8 conventions, full RSpec test coverage, and strict code quality standards.

## Getting Started

### 1. Prerequisites
Ensure you have mise installed or your preferred Ruby version manager:
```bash
mise install
```

### 2. Install Dependencies
```bash
bundle install
```

### 3. Database Setup & Seeding
```bash
bin/rails db:migrate
bin/rails db:seed
```

### 4. Run Tests & Coverage
```bash
bundle exec rspec
```
Code coverage report will be automatically generated at `coverage/index.html`.

### 5. Run Linter
```bash
bundle exec rubocop
```

## Testing with cURL

### Obtain Token:
```bash
curl -X POST http://localhost:3000/api/v1/tokens \
  -H "Content-Type: application/json" \
  -d '{"user": {"email": "user@example.com", "password": "password123"}}'
```

### Fetch Paginated Products:
```bash
curl -H "Accept: application/json" "http://localhost:3000/api/v1/products?page=1&per_page=10"
```

### Place Order:
```bash
curl -X POST http://localhost:3000/api/v1/orders \
  -H "Content-Type: application/json" \
  -H "Authorization: <YOUR_JWT_TOKEN>" \
  -d '{"order": {"product_ids_and_quantities": [{"product_id": 1, "quantity": 2}]}}'
```
