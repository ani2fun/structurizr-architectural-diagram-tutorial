# Structurizr On-Premise Installation Guide

This guide covers the setup, configuration, and usage of Structurizr on-premise with Docker.

Big thanks to Daniel Derevynsky for his insightful [YouTube video](https://www.youtube.com/watch?v=lFoPvGIqvzc). His work provided the foundation for these examples.

## Prerequisites

- **Docker**: Ensure Docker is installed and running on your machine.
- **Network and Port Configuration**: Ensure the intended ports (default `8085` in this guide) are available for Structurizr access.
- **Data Directory**: Prepare a directory for storing Structurizr data and configuration files.

## Table of Contents

1. [Setup Instructions](#setup)
2. [Configuration Files](#config-files)
3. [Running Structurizr with Docker Compose](#docker-compose)
4. [Creating and Managing Workspaces](#workspaces)
5. [Using the Structurizr CLI](#cli)
6. [Exporting Workspaces](#exporting)
7. [Validating and Pushing Workspaces](#validate-push)
8. [Optional: Building from Source Code](#build-source)

---

## <a name="setup"></a>Setup Instructions

1. **Using Docker Compose**:
   ```bash
   docker-compose up -d
   ```
   
2. **Access Structurizr**:
   Visit [http://localhost:8085](http://localhost:8085) in your browser. Use the following default credentials:
   - **Username**: `structurizr`
   - **Password**: `password`

---

## <a name="config-files"></a>Configuration Files

### `structurizr.properties`

- Located in `./structurizr-data-store/structurizr.properties`.
- This file contains configuration for Structurizr, including API keys and other security settings.
- For example:
  ```console
  structurizr.url=http://localhost:8085
  structurizr.apiKey=$2a$10$t3U.QeK.ZuELsjd9fRaw7OZX8j51j.64OJyvbufQLpPCKzCLd4Hgq
  ```
- To generate a hashed API_KEY for Structurizr, visit:
    - ```http
      http://localhost:8085/bcrypt/{API_KEY}
      ```
    - Replace `{API_KEY}` with your desired KEY.

### `structurizr.users`

- Located in `./structurizr-data-store/structurizr.users`.
- Defines user credentials and hashed passwords for accessing Structurizr.
- To generate a hashed password for Structurizr, visit:
    - ```http
      http://localhost:8085/bcrypt/{YOUR_PASSWORD}
      ```
    - Replace `{YOUR_PASSWORD}` with your desired password.

---

## <a name="docker-compose"></a>Running Structurizr with Docker Compose

Create a `docker-compose.yaml` file with the following content to simplify and control the deployment:

```yaml
version: '3.8'

services:
  structurizr:
    image: structurizr/onpremises
    container_name: structurizr-onpremise
    ports:
      - "8085:8080"  # Expose the Structurizr port on 8085
    volumes:
      - ./structurizr-data-store:/usr/local/structurizr  # Mount the data directory
    environment:
      - STRUCTURIZR_PROPERTIES_FILE=/usr/local/structurizr/structurizr.properties
```

Run Structurizr:
```bash
docker-compose up -d
```

---

## <a name="workspaces"></a>Creating and Managing Workspaces

### Create a New Workspace

- **Via Web UI**: Log in to Structurizr at [http://localhost:8085](http://localhost:8085) and click "New Workspace."
- **Via API**:
- ```bash
  curl -X POST -H "X-Authorization: YOUR_API_KEY" http://localhost:8085/api/workspace
  ```

### Retrieve All Workspaces

- ```bash
  curl -X GET -H "X-Authorization: YOUR_API_KEY" http://localhost:8085/api/workspace
  ```
- Example output:
    ```json
    {"workspaces":[{"id":1,"name":"Workspace 0001","description":"Description","apiKey":"API_KEY","apiSecret":"API_SECRET","privateUrl":"http://localhost:8085/workspace/1","publicUrl":"http://localhost:8085/share/1","shareableUrl":""}]}
    ```

---

## <a name="cli"></a>Using the Structurizr CLI

The [Structurizr CLI](https://docs.structurizr.com/cli/installation) is helpful for automation, validation, and workspace management.

### Install Structurizr CLI

On MacOS:
```bash
brew install structurizr-cli
```

### Obtain API Key and Other Structurizr CLI parameters for a workspace:

- Go to Workspace Settings: e.g.[Worksapce Settings](http://localhost:8085/workspace/1/settings)
- Copy **Structurizr CLI parameters**
  - for example: `-url http://localhost:8085/api -id 1 -key 71b9ed19-3b95-41e2-845d-54b7dda3618d -secret 8c43d9cc-b551-4bb6-95e7-2f172baef35f`

### Push to a Workspace

```bash
structurizr-cli push -url http://localhost:8085/api -id WORKSPACE_ID -key YOUR_API_KEY -secret YOUR_API_SECRET -workspace path/to/workspace.dsl
```

Example:
```bash
structurizr-cli push -url http://localhost:8085/api -id 1 -key API_KEY -secret API_SECRET -workspace 0_introduction/workspace.dsl
```

## <a name="exporting"></a>Exporting Workspaces

Export a workspace to various formats using Structurizr CLI:

```bash
structurizr-cli export -workspace path/to/workspace.dsl -format <format> -output path/to/output/folder
```

Replace `<format>` with one of `json`, `plantuml`, `mermaid`, or `ilograph` and specify the desired output directory.

---

### Export Formats and Examples

1. **JSON Export**:
   ```bash
   structurizr-cli export -workspace path/to/workspace.dsl -format json -output path/to/output/json
   ```

2. **PlantUML Export**:
   ```bash
   structurizr-cli export -workspace path/to/workspace.dsl -format plantuml -output path/to/output/plantuml
   ```

3. **Mermaid Export**:
   ```bash
   structurizr-cli export -workspace path/to/workspace.dsl -format mermaid -output path/to/output/mermaid
   ```

4. **Ilograph Export**:
   ```bash
   structurizr-cli export -workspace path/to/workspace.dsl -format ilograph -output path/to/output/ilograph
   ```

## <a name="validate-push"></a>Validating and Pushing Workspaces

### General Push Format

```bash
structurizr-cli validate -workspace path/to/workspace.dsl
structurizr-cli push -url http://localhost:8085/api -id WORKSPACE_ID -key API_KEY -secret API_SECRET -workspace path/to/workspace.dsl
```

### Push Examples by Workspace ID

---

#### Push to Workspace ID: 1
```bash
structurizr-cli validate -workspace workspace.dsl
structurizr-cli push -url http://localhost:8085/api -id 1 -key 71b9ed19-3b95-41e2-845d-54b7dda3618d -secret 8c43d9cc-b551-4bb6-95e7-2f172baef35f -workspace workspace.dsl
```

#### Push to Workspace ID: 2
```bash
structurizr-cli validate -workspace workspace.dsl
structurizr-cli push -url http://localhost:8085/api -id 2 -key 033527c5-49fc-4010-8a3f-0dd9dbb80b0c -secret 72ae07cc-c959-43b2-babf-fe417191ce55 -workspace workspace.dsl
```

#### Push to Workspace ID: 3
```bash
structurizr-cli validate -workspace workspace.dsl
structurizr-cli push -url http://localhost:8085/api -id 3 -key 689b237e-fc7b-47ed-bc1b-fc3589a2b273 -secret d17ea158-6782-4194-9853-9f48070c1293 -workspace workspace.dsl
```

#### Push to Workspace ID: 4
```bash
structurizr-cli validate -workspace workspace.dsl
structurizr-cli push -url http://localhost:8085/api -id 4 -key 89d6949a-1db6-4788-aa97-cfe56d1fd50d -secret 74ad006d-0e8f-4329-be33-6cf7a73e5186 -workspace workspace.dsl
```

#### Push to Workspace ID: 5
```bash
structurizr-cli validate -workspace workspace.dsl
structurizr-cli push -url http://localhost:8085/api -id 5 -key a0555cd0-4f00-4182-bead-59bcf599c5e8 -secret 0f177bf2-a83e-4a1

f-a685-631ac034178e -workspace workspace.dsl
```

#### Push to Workspace ID: 6
```bash
structurizr-cli validate -workspace workspace.dsl
structurizr-cli push -url http://localhost:8085/api -id 6 -key bc2a804e-bd1c-4354-a0df-f8ec38812e32 -secret 231c8c68-f8f4-4df6-8739-54baf56ba35a -workspace workspace.dsl
```

---

## <a name="build-source"></a>Optional: Building from Source Code

If you'd like to build Structurizr on-premise from the source, follow these steps:

### Step 1: Clone the Source Repositories

Clone both the on-premise server and the UI repositories:

```bash
git clone https://github.com/structurizr/onpremises.git structurizr-onpremises
git clone https://github.com/structurizr/ui.git structurizr-ui
```

### Step 2: Build the UI and Server

1. **Navigate to the `structurizr-onpremises` directory**:
   ```bash
   cd structurizr-onpremises
   ```

2. **Build the UI**: This command will pull the latest UI files into the server:
   ```bash
   ./ui.sh
   ```

3. **Build the Application**:
   - Use Gradle to build the application, skipping integration tests if necessary:
     ```bash
     ./gradlew clean build -x integrationTest
     ```

   - If the build succeeds, you should see a file named `structurizr-onpremises.war` in the `structurizr-onpremises/build/libs` directory.

### Step 3: Create a Docker Image

To containerize your custom build, follow these steps:

1. **Navigate to the `structurizr-onpremises` directory** (if not already there):
   ```bash
   cd structurizr-onpremises
   ```

2. **Build the Docker Image**:
   ```bash
   docker build . -t structurizr-onpremise-local
   ```

### Step 4: Run the Docker Container

Start a Docker container using the custom-built image. Replace `/path/to/dataDirectory` with the actual path to your data directory:

```bash
docker run -it --rm -p 8080:8080 -v /path/to/dataDirectory:/usr/local/structurizr structurizr-onpremise-local
```

- This command runs the Structurizr on-premise application on port `8080`.
- You can access it by visiting [http://localhost:8080](http://localhost:8080) in your browser.

By building from source, you can customize Structurizr as needed or include it in your CI/CD pipeline for automated deployment. Make sure to test your build and verify configurations for production use.