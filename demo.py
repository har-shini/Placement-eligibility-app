import streamlit as st
import mysql.connector
import pandas as pd

# MySQL Connection
def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="Harshu@08",
        database="placement_db"
    )

# Page Title
st.title("Placement Eligibility Checker")

# Filters
st.sidebar.header("Eligibility Criteria")
min_problems = st.sidebar.slider("Minimum Problems Solved", 0, 100, 50)
min_soft_skills = st.sidebar.slider("Minimum Average Soft Skill Score", 50, 100, 75)

# SQL Query
query = f"""
SELECT s.student_id, s.name, p.problems_solved,
       ROUND((ss.communication + ss.teamwork + ss.presentation)/3, 2) AS avg_soft_skills,
       pl.placement_ready
FROM Students s
JOIN Programming p ON s.student_id = p.student_id
JOIN SoftSkills ss ON s.student_id = ss.student_id
JOIN Placements pl ON s.student_id = pl.student_id
WHERE p.problems_solved >= {min_problems}
  AND ((ss.communication + ss.teamwork + ss.presentation)/3) >= {min_soft_skills}
"""

# Execute
conn = get_connection()
df = pd.read_sql(query, conn)
conn.close()

# Display
st.subheader("Eligible Students")
st.dataframe(df)

# Show top 5 placement-ready students
conn = get_connection()
top_5 = pd.read_sql("""
SELECT s.name, pl.mock_interview_score
FROM Students s
JOIN Placements pl ON s.student_id = pl.student_id
WHERE pl.placement_ready = 'Yes'
ORDER BY pl.mock_interview_score DESC
LIMIT 5;
""", conn)
conn.close()

st.subheader("Top 5 Placement-Ready Students")
st.table(top_5)

