$('#modal').on('shown.bs.modal', function () {
    $(this).removeData('bs.modal');
});