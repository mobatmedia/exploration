using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace MatchingGame
{
    public partial class Form1 : Form
    {
        // Use this Random object to choose random icons for the squares
        Random random = new Random(17654);

        // Each of these letters is an interesting icon
        // in the Webdings font, and each icon appears 
        // twice in this list.
        List<string> icons = new List<string>()
        {
            "!", "!", "N", "N", ",", ",", "k", "k",
            "b", "b", "v", "v", "w", "w", "z", "z"
        };

        // firstClicked points to the first Label control 
        // that the player clicks, but it will be null 
        // if the player hasn't clicked a label yet
        Label firstClicked = null;

        // secondClicked points to the second Label control 
        // that the player clicks
        Label secondClicked = null;

        // elapsedSecs is the number of seconds elapsed since the first click.
        int elapsedSecs = 0;

        public Form1()
        {
            InitializeComponent();

            AssignIconsToSquares();
        }

        /// <summary>
        /// Assign each icon from the list of icons to a random square.
        /// </summary>
        private void AssignIconsToSquares()
        {
            // The TableLayoutPanel has 16 labels,
            // and the icon list has 16 icons,
            // so an icon is pulled at random from the list
            // and added to each label.
            List<string> iconList = new List<string>(icons);
            foreach (Control control in tableLayoutPanel1.Controls)
            {
                Label iconLabel = control as Label;
                if (iconLabel != null)
                {
                    int randomNumber = random.Next(iconList.Count);
                    iconLabel.Text = iconList[randomNumber];
                    iconLabel.ForeColor = iconLabel.BackColor;
                    iconList.RemoveAt(randomNumber);
                }
            }
            elapsedSecs = 0;
            elapsedLabel.Text = elapsedSecs.ToString();
        }
        
        /// <summary>
        /// Hide all icons.
        /// </summary>
        private void HideIcons()
        {
            foreach (Control control in tableLayoutPanel1.Controls)
            {
                Label iconLabel = control as Label;
                if (iconLabel != null)
                {
                    iconLabel.ForeColor = iconLabel.BackColor;
                }
            }
        }

        /// <summary>
        /// To be successful, the timer annot be running. An icon has been
        /// matched if its foreground color equals its background color.
        /// If every icon is matched, the player wins.
        /// </summary>
        private void CheckForWinner()
        {
            // The timer is only on after two non-matching 
            // icons have been shown to the player, so the
            // test fails if the timer is running.
            if (timer1.Enabled == true)
                return;

            // Go through all of the labels in the TableLayoutPanel, 
            // checking each one to see if its icon is matched.
            foreach (Control control in tableLayoutPanel1.Controls)
            {
                Label iconLabel = control as Label;

                if (iconLabel != null)
                {
                    if (iconLabel.ForeColor == iconLabel.BackColor)
                        return;
                }
            }

            // If the loop didn’t return from the test, all icons are matched.
            // Stop the elapsed time timer, show a message, and reset the form.
            elapsedTimer.Stop();
            MessageBox.Show("You matched all the icons!", "Congratulations");
            HideIcons();
            AssignIconsToSquares();
        }

        /// <summary>
        /// Every label's Click event is handled by this event handler
        /// </summary>
        /// <param name="sender">The label that was clicked</param>
        /// <param name="e"></param>
        private void label_Click(object sender, EventArgs e)
        {
            // The timer is only on after two non-matching 
            // icons have been shown to the player, 
            // so ignore any clicks if the timer is running
            if (timer1.Enabled)
                return;

            Label clickedLabel = sender as Label;

            if (clickedLabel != null)
            {
                // If the elapsed timer is not enabled, start it.
                if (!elapsedTimer.Enabled)
                {
                    elapsedSecs = 0;
                    elapsedLabel.Text = elapsedSecs.ToString();
                    elapsedTimer.Start();
                }

                // If the clicked label is black, the player clicked
                // an icon that's already been revealed --
                // ignore the click
                if (clickedLabel.ForeColor == Color.Black)
                    return;

                // If firstClicked is null, this is the first icon 
                // in the pair that the player clicked. Set firstClicked
                // to the label that the player clicked, change its color
                // to black, and return.
                if (firstClicked == null)
                {
                    firstClicked = clickedLabel;
                    firstClicked.ForeColor = Color.Black;
                    return;
                }

                // The timer isn't running and firstClicked isn't null.
                // This is the second icon the player clicked.
                // Set its color to black.
                secondClicked = clickedLabel;
                secondClicked.ForeColor = Color.Black;

                // If the icons match, reset firstClicked and secondClicked.
                // Check to see whether the user has won.
                if (firstClicked.Text == secondClicked.Text)
                {
                    firstClicked = null;
                    secondClicked = null;
                    CheckForWinner();
                    return;
                }

                // The icons didn't match, so start the timer.
                timer1.Start();
            }
        }

        /// <summary>
        /// The timer is started when the player clicks two icons that don't match.
        /// Count three quarters of a second, then turn off and hides both icons.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void timer1_Tick(object sender, EventArgs e)
        {
            // Stop the timer
            timer1.Stop();

            // Hide both icons
            firstClicked.ForeColor = firstClicked.BackColor;
            secondClicked.ForeColor = secondClicked.BackColor;

            // Reset firstClicked and secondClicked so the next time a label
            // is clicked, the program knows it's the first click.
            firstClicked = null;
            secondClicked = null;
        }

        // <summary>
        // The timer is started when the player has clicked an icon.
        // It is stopped when the game is finished.
        // It updates the number of elapsed seconds, and the label.
        // </summary>
        private void elapsedTimer_Tick(object sender, EventArgs e)
        {
            ++elapsedSecs;
            elapsedLabel.Text = elapsedSecs.ToString();
        }
    }
}
