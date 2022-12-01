using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CaffShop.DAL.Migrations
{
    public partial class entities : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Caffs",
                columns: new[] { "Id", "FileName", "ImgURL", "OwnerId", "Title", "UniqueFileName" },
                values: new object[] { 1, "Test", "Test", 2, "Caff test entity", "Test" });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Caffs",
                keyColumn: "Id",
                keyValue: 1);
        }
    }
}
