import sqlite3

DB_NAME = "students.db"

def connect_db():
    return sqlite3.connect(DB_NAME)

def setup_database():
    conn = connect_db()
    cursor = conn.cursor()

    with open("create_tables.sql", "r") as f:
        cursor.executescript(f.read())

    with open("insert_data.sql", "r") as f:
        cursor.executescript(f.read())

    conn.commit()
    conn.close()
    print("✅ Database setup completed")

def show_menu():
    print("\n--- Student Database Management ---")
    print("1. Show all students")
    print("2. Average score")
    print("3. Top 5 students")
    print("4. Bottom 5 students")
    print("5. Count students by department")
    print("6. Exit")

def run_query(query):
    conn = connect_db()
    cursor = conn.cursor()
    cursor.execute(query)
    rows = cursor.fetchall()
    conn.close()
    return rows

def main():
    setup_database()

    while True:
        show_menu()
        choice = input("Enter choice: ")

        if choice == "1":
            rows = run_query("SELECT * FROM students")
        elif choice == "2":
            rows = run_query("SELECT AVG(score) FROM students")
        elif choice == "3":
            rows = run_query("SELECT name, score FROM students ORDER BY score DESC LIMIT 5")
        elif choice == "4":
            rows = run_query("SELECT name, score FROM students ORDER BY score ASC LIMIT 5")
        elif choice == "5":
            rows = run_query("SELECT department, COUNT(*) FROM students GROUP BY department")
        elif choice == "6":
            print("Exiting...")
            break
        else:
            print("Invalid choice")
            continue

        for r in rows:
            print(r)

if __name__ == "__main__":
    main()
