<body>
<?php
        //open a connection to dbase server
        include 'open.php';

        $president = $_POST['president'];
        echo "<br><br>";
	echo "You entered ";
	echo $president;
if (empty($president)){
   echo "ERROR: President not found ";
   echo $president;
   echo " not found";
} else if (!empty($president)){
        if ($result = $conn->query("CALL TopArtistByPresident('".$president."');")) {
           echo "<table border=\"2px solid black\">";
           echo "<tr><td>President</td><td>Top Artist</td>";
           foreach($result as $row){
                //to improve the look of the output, we could add html table
                //tags too, which would add border lines, center the values, etc.
                echo "<tr>";
                echo "<td>".$row["president"]."</td>";
                echo "<td>".$row["artist"]."</td>";
                echo "</tr>";
            }
            echo "</table>";
        }
}

        //close the connection to dbase
        $conn->close();

?>
</body>
