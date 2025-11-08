# Bash Scripting Practical Assessment
## DevOps Engineer Position - KapaMech Data Solutions Limited

---

## **Assessment Instructions**

### **Scenario**
You are an entry-level DevOps engineer at KapaMech Data Solutions Limited, a data engineering company in Lagos specializing in Data Warehousing and AI solutions. Your team needs to automate user account management for new data engineering projects.

### **Project Setup & Requirements**

**Time Allotted:** 3 hours  
**Submission Requirements:** Push all code to a GitHub repository and share the link

---

## **Assessment Tasks**

### **Task 1: Project Repository Setup (15 points)**
1. Clone the assessment data repository:
   ```
   https://github.com/theoafactor/devops_stage1_assess_data
   ```
2. Remove the existing Git history and make this your own project
3. Create a new GitHub repository and push the code to your account
4. Create a proper project structure with organized directories

### **Task 2: Account Creation Script (35 points)**
Write a bash script `create_users.sh` that:
- Reads user data from `accounts.txt`
- Creates Linux user accounts for each entry in the file
- Sets up home directories with proper permissions
- Generates secure random passwords for each account
- Ensures accounts are login-ready
- Implements proper error handling for existing users

### **Task 3: Advanced Account Management Features (50 points)**
Extend your script with the following administrative functions:

#### **3.1 Account Deletion Function (15 points)**
- Create function `delete_user_account` that:
  - Removes user accounts while preserving their data
  - Archives home directories before deletion
  - Provides confirmation prompts for safety

#### **3.2 Password Management Function (10 points)**
- Create function `update_user_password` that:
  - Allows password updates for existing users
  - Enforces password complexity requirements
  - Logs password change activities

#### **3.3 Group Management Functions (15 points)**
- Create function `add_user_to_group` that:
  - Adds users to specified secondary groups
  - Verifies group existence before adding users
  - Handles multiple group assignments

- Create function `remove_user_from_group` that:
  - Removes users from specified groups
  - Prevents removal from primary groups
  - Validates group membership before removal

#### **3.4 Logging and Reporting (10 points)**
- Implement comprehensive logging of all actions
- Generate summary reports of operations performed
- Create backup mechanisms for critical operations

---

## **Technical Requirements**

### **Script Requirements:**
- Must include proper shebang line
- Implement error handling and input validation
- Include meaningful comments and documentation
- Use functions for modular code organization
- Handle edge cases (existing users, invalid data, etc.)

### **Security Considerations:**
- Secure password generation and handling
- Proper file permissions
- Safe deletion practices
- Input sanitization

### **Code Quality:**
- Clean, readable code structure
- Consistent naming conventions
- Proper exit codes and status reporting

---

## **Deliverables**

1. **Main Script:** `create_users.sh`
2. **Configuration Files:** Any supporting files used
3. **Documentation:** `README.md` with:
   - Setup instructions
   - Usage examples
   - Function descriptions
4. **Log Files:** Sample output and error logs
5. **GitHub Repository:** With complete commit history

---

## **Evaluation Criteria**

| **Category** | **Weight** | **Description** |
|-------------|------------|-----------------|
| **Functionality** | 40% | Script performs all required tasks correctly |
| **Code Quality** | 25% | Clean, readable, well-organized code |
| **Error Handling** | 15% | Proper validation and error management |
| **Documentation** | 10% | Clear comments and README documentation |
| **Git Usage** | 10% | Proper commit history and repository management |

---

## **Submission Instructions**

1. Complete all tasks within the time limit
2. Push your code to GitHub
3. Ensure your repository includes:
   - All script files
   - Documentation
   - Sample output/logs
4. Share the GitHub repository link with your instructor

**Note:** This assessment tests your practical bash scripting skills in a real-world DevOps scenario. Good luck!