# Layers Module

Creates Lambda layers for Python dependencies to optimize deployment size and enable code reuse.

## Resources Created

- **Lambda Layer**: Contains Python packages for Lambda functions
- **Layer Version**: Versioned layer with dependency packages

## Usage

```hcl
module "layers" {
  source = "./modules/layers"
  
  project_name = "my-project"
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_name | Project name for layer naming | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| layer_arn | ARN of Lambda layer |

## Layer Contents

The layer includes Python packages from `layers/requirements.txt`:
- **requests**: HTTP library for API calls
- **pandas**: Data manipulation and analysis
- **numpy**: Numerical computing support

## Directory Structure

```
layers/
└── python/
    └── lib/
        └── python3.9/
            └── site-packages/
                ├── requests/
                ├── pandas/
                └── numpy/
```

## Benefits

- **Reduced Package Size**: Function code separated from dependencies
- **Faster Deployments**: Dependencies cached in layers
- **Code Reusability**: Layers shared across multiple functions
- **Version Management**: Independent versioning of code and dependencies

## Build Process

1. Install dependencies: `pip install -r layers/requirements.txt -t layers/python/lib/python3.9/site-packages`
2. Create layer zip: Archive `layers/python` directory
3. Deploy layer: Terraform creates versioned layer resource

## Compatible Runtimes

- Python 3.9