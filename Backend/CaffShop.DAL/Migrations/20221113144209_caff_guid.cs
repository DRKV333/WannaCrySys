using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CaffShop.DAL.Migrations
{
    public partial class caff_guid : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "UniqueFileName",
                table: "Caffs",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "UniqueFileName",
                table: "Caffs");
        }
    }
}
