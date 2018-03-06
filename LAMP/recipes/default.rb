#
# Cookbook Name:: lamp
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "httpd" do
  action :install
end
service "httpd" do
  action [:enable, :start]
end
package "mysql" do
action :install
end
package "mysql-server"
package "mysql-libs"
package "mysql-server"
#package "telnet"
#package "ftp"
service "mysqld" do
 action [:enable, :start]
end
script 'php' do
interpreter "bash"
code <<-EOH
yum install php* -y
EOH
end
file '/var/www/html/index.php' do
content '<!DOCTYPE html>
<body>
 <h1>hello world</h1>
<?php
echo "Connected successfully";
 echo "<p>Hello World</p>";
$servername = "localhost";
$username = "root";
$password = "Admin098";

// Create connection
//$conn = new mysqli($servername, $username, $password);

// Check connection
// if ($conn->connect_error) {
  //  die("Connection failed: " . $conn->connect_error);
//} 
//echo "Connected successfully";
$dbname = "test1";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 

$sql = "SELECT * FROM emp";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
        echo "name: " . $row["name"]. " - id: " . $row["id"]. "<br>";
    }
} else {
    echo "0 results";
}
 $conn->close();


?>
</body>
</html>'
end


