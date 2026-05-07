# 🧪 Testing

## Owner

**Member 4**

## Responsibility

Ensure the AutoOps AI system works end-to-end. Testing is critical for verifying that the entire pipeline — from user prompt to deployed Flask app — functions correctly. In Phase 1, focus on integration testing of the full deployment flow and API endpoint testing.

## Test Case — End-to-End Deployment

### Input
```json
{
  "prompt": "deploy flask app"
}
```

### Expected Results

1. ✅ API returns `200 OK` with JSON response
2. ✅ Response contains `status`, `ip`, and `url` fields
3. ✅ EC2 instance is created on AWS
4. ✅ Flask app is deployed and accessible at the returned URL
5. ✅ Visiting `http://<ip>:5000` returns a valid HTTP response

## Tools

| Tool       | Purpose                                    |
|------------|---------------------------------------------|
| **Postman** | Manual API testing during development      |
| **pytest**  | Automated test suite                       |
| **curl**    | Quick command-line API testing             |

## File

| File                  | Purpose                                   |
|-----------------------|-------------------------------------------|
| `test_deploy_flow.py` | End-to-end deployment flow test           |

## Test Scenarios

### 1. API Endpoint Test
```python
# Test POST /deploy returns correct response format
def test_deploy_endpoint():
    response = client.post("/deploy", json={"prompt": "deploy flask app"})
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "success"
    assert "ip" in data
    assert "url" in data
```

### 2. Planner Agent Test
```python
# Test planner converts prompt to correct plan
def test_planner():
    plan = planner.run("deploy flask app")
    assert plan["app"] == "flask"
    assert plan["instance_type"] == "t2.micro"
    assert plan["region"] == "ap-south-1"
```

### 3. Invalid Input Test
```python
# Test API handles missing prompt gracefully
def test_deploy_missing_prompt():
    response = client.post("/deploy", json={})
    assert response.status_code == 422  # Validation error
```

## Tasks for Member 4

1. Write `test_deploy_flow.py` with end-to-end test cases
2. Test the API endpoint with valid and invalid inputs
3. Test the Planner Agent with various prompts
4. Use `moto` library to mock AWS calls (avoid creating real EC2 instances in tests)
5. Document test results and edge cases

## Running Tests

```bash
# Run all tests
pytest tests/ -v

# Run with print output
pytest tests/ -v -s

# Run specific test
pytest tests/test_deploy_flow.py -v
```
