students = {}

while True:
    print("\n---Student Grade Entry---")
    print("1. Add new Student")
    print("2. Update Student Grade")
    print("3. Display All Students Grades")
    print("4. Exit")

    choice = input("Enter your choice (1-4): ")

    # Add new Student
    if choice == '1':
        name = input("Enter student name (or 'exit' to finish): ")
        if name.lower() == 'exit':
            break
        grade = input("Enter student grade: ")
        students[name] = grade

    # Update Student Grade   
    elif choice == '2':
        name = input("Enter student name to update: ")
        if name in students:
            grade = input("Enter new student grade: ")
            students[name] = grade
            print(f"Grade for {name} updated successfully.")
        else:
            print("Student not found.")

    # Display All Students Grades
    elif choice == '3':
        if students:
            print("\n---All Students---")
            for name, grade in students.items():
                print(f"Name: {name}, Grade: {grade}")
        else:
            print("No students found.")
    
    # Exit
    elif choice == '4':
        print("Exiting...")
        break
    
    else:
        print("Invalid choice. Please enter a valid option.")