$(document).ready(function() {
    // Show the confirmation modal when the "Delete" button is clicked
    $('.delete-item').click(function(event) {
        event.preventDefault(); // Prevent the default form submission
        $('#confirmationModal').modal('show');
    });

    // Update the action of the form to include a confirmation parameter when the modal is shown
    $('#confirmationModal').on('show.bs.modal', function(event) {
        const form = $('.delete-item');
        const originalAction = form.attr('action');
        const actionWithConfirmation = originalAction + '?confirmation=yes';
        form.attr('action', actionWithConfirmation);
    });

    // Handle the "Delete" link click in the modal
    $('#confirmDeleteLink').click(function(event) {
        // Manually submit the form with the updated action
        event.preventDefault(); // Prevent the default form submission
        $('.delete-item').submit();
    });
});