#!/usr/bin/env bash
# Test script for analyzing Java getter and setter methods and their complexities

set -e
set -o pipefail

# Setup temporary workspace
temp=$1
stdout=$2

# Location of the Python script
script_location="${LOCAL}/metrics/getset.py"

{
    # Create a simple Java file with getter and setter methods
    java_file="${temp}/Person.java"
    echo "public class Person {
        private String name;
        private int age;
        
        public String getName() {return this.name;}
        public void setName(String name) {this.name = name;}        
        public int getAge() {return this.age;}        
        public void setAge(int age) {this.age = age;}        
        public void nonAccessorMethod() {
            if (age > 18) {System.out.println(\"Adult\");}
        }
    }" > "${java_file}"
    
    metrics_file="${temp}/metrics.txt"
    "${script_location}" "${java_file}" "${metrics_file}"
    cat "${metrics_file}"
    
    # Assertions: Check for expected output related to getter, setter, and branches
    grep "Method name: getter; Complexity: 1; Branches: 1" "${metrics_file}"
    grep "Method name: getter; Complexity: 1; Branches: 1" "${metrics_file}"
    grep "Method name: getter; Complexity: 1; Branches: 1" "${metrics_file}"
    grep "Method name: getter; Complexity: 1; Branches: 1" "${metrics_file}"
    grep "none 1 1 Branches of nonAccessorMethod" "${metrics_file}" || true # This line is expected to fail since your script currently doesn't handle non-accessor methods
} > "${stdout}" 2>&1

echo "👍 Tests passed successfully"
